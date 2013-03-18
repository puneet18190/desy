require 'csv'

# These requires are needed by multithreading
require 'filename_token'
require 'statuses'
require 'users_subject'
require 'media_element'
require 'audio'
require 'video'
require 'image_uploader'
require 'image'
require 'lesson'
require 'tagging'
require 'location'
require 'school_level'
require 'subject'
require 'valid'
require 'user'
require 'slide'
require 'media_elements_slide'
require 'like'
require 'bookmark'
require 'tag'
require 'report'

class Seeding
  CSV_DIR     = Rails.root.join("db/seeds/environments/#{Rails.env}/csv")
  CSV_OPTIONS = { headers: true }

  PUBLIC_MEDIA_ELEMENTS_FOLDER     = Media::Uploader::MEDIA_ELEMENTS_FOLDER
  OLD_PUBLIC_MEDIA_ELEMENTS_FOLDER = "#{PUBLIC_MEDIA_ELEMENTS_FOLDER}.old"

  MEDIA_ELEMENTS_FOLDER = Rails.root.join "db/seeds/environments/#{Rails.env}/media_elements"
  AUDIOS_FOLDER         = MEDIA_ELEMENTS_FOLDER.join 'audios'
  VIDEOS_FOLDER         = MEDIA_ELEMENTS_FOLDER.join 'videos'
  IMAGES_FOLDER         = MEDIA_ELEMENTS_FOLDER.join 'images'

  MODELS = [ Location, SchoolLevel, Subject, User, MediaElement, Lesson, Slide, MediaElementsSlide, Like, Bookmark ]
  # MODELS = [ MediaElement, Lesson, Slide, MediaElementsSlide, Like, Bookmark ]

  def run
    

    puts "Applying #{Rails.env} seeds (#{MODELS.map{ |m| humanize_table_name(m.table_name) }.join(', ')})"

    FileUtils.rm_rf OLD_PUBLIC_MEDIA_ELEMENTS_FOLDER
    begin
      FileUtils.mv PUBLIC_MEDIA_ELEMENTS_FOLDER, OLD_PUBLIC_MEDIA_ELEMENTS_FOLDER
    rescue Errno::ENOENT
    end

    # FIXME la transazione non rollbackka (a causa dei thread probabilmente)
    # ActiveRecord::Base.transaction do
      MODELS.each do |model|
        @model, @table_name = model, model.table_name
        p @table_name
        set_rows_amount
        send :"#{@table_name}!"
        update_sequence
      end

      # raise ActiveRecord::Rollback

      FileUtils.rm_rf OLD_PUBLIC_MEDIA_ELEMENTS_FOLDER
    # end

    puts 'End.'
  rescue StandardError => e
    FileUtils.rm_rf PUBLIC_MEDIA_ELEMENTS_FOLDER
    begin
      FileUtils.mv OLD_PUBLIC_MEDIA_ELEMENTS_FOLDER, PUBLIC_MEDIA_ELEMENTS_FOLDER
    rescue Errno::ENOENT
    end

    raise e
  end

  private

  def humanize_table_name(table_name = @table_name)
    table_name.tr('_', ' ')
  end

  def csv_path(filename = @table_name)
    CSV_DIR.join "#{filename}.csv"
  end

  def csv_open(csv_path = csv_path)
    CSV.open(csv_path, CSV_OPTIONS)
  end

  def users_subjects(id)
    @each_users_subjects ||= CSV.read(csv_path('users_subjects'), CSV_OPTIONS).each
    @each_users_subjects.select { |row|
      row['user_id'] == id.to_s
    }.map { |row|
      row['subject_id']
    }
  end

  def media(record)
    case record
    when Audio
      v = Pathname.glob(AUDIOS_FOLDER.join record.id.to_s, '*.mp3').first
      { mp3: v.to_s, ogg: v.sub(/\.mp3$/, '.ogg').to_s, filename: v.basename(v.extname).to_s }
    when Video
      v = Pathname.glob(VIDEOS_FOLDER.join record.id.to_s, '*.mp4').first
      { mp4: v.to_s, webm: v.sub(/\.mp4$/, '.webm').to_s, filename: v.basename(v.extname).to_s }
    when Image
      File.open Pathname.glob(IMAGES_FOLDER.join(record.id.to_s, Image::EXTENSIONS_GLOB), File::FNM_CASEFOLD).first
    end
  end

  def tags(id, type)
    csv_open(csv_path('taggings')).each.select do |row|
      row['taggable_type'] == type && row['taggable_id'] == id.to_s
    end.map do |taggable_row|
      csv_open(csv_path('tags')).each.
        detect{ |tags_row| taggable_row['tag_id'] == tags_row['id'] }['word']
    end.join(',')
  end

  def csv_row_to_record(row, model = @model)
    model.new { |record| row.headers.each { |header| record.send :"#{header}=", row[header] } }
  end

  def update_sequence
    @model.connection.reset_pk_sequence! @table_name
  end

  def progress(i)
    # n = i+1

    # $stdout.print "  saving #{n.ordinalize} of #{@rows_amount} #{humanize_table_name}\r"
    # $stdout.flush

    # return if n != @rows_amount

    # $stdout.puts
    # $stdout.flush
  end

  def set_rows_amount
    @rows_amount = csv_open.readlines.count
  end

  def locations!
    EnhancedThread.join *csv_open.each.each_with_index.map { |row, i|
      proc {
        progress(i)
        csv_row_to_record(row).save!
      }
    }
  end

  def school_levels!
    EnhancedThread.join *csv_open.each.each_with_index.map { |row, i|
      proc {
        progress(i)
        csv_row_to_record(row).save!
      }
    }
  end

  def subjects!
    EnhancedThread.join *csv_open.each.each_with_index.map { |row, i|
      proc {
        progress(i)
        csv_row_to_record(row).save!
      }
    }
  end

  def users!
    EnhancedThread.join *csv_open.each.each_with_index.map { |row, i|
      proc {
        progress(i)
        record = csv_row_to_record(row)
        record.subject_ids = users_subjects(record.id)
        record.accept_policies
        record.save!
      }
    }
  end

  def media_elements!
    MediaElement.destroy_all
    EnhancedThread.join *csv_open.each.each_with_index.map { |row, i|
      proc {
        progress(i)
        begin
          record = csv_row_to_record(row, row['sti_type'].constantize)
          str = "media_element #{record.id}..."
          record.media                   = media(record)
          record.skip_public_validations = true
          record.tags                    = tags(record.id, 'MediaElement')
          record.save!
          str << " saved. id: #{record.id}"
          puts str
        rescue ActiveRecord::StatementInvalid, Errno::ENOENT => e
          Thread.current[:attempts] ||= 0
          Thread.current[:attempts] += 1
          str << " :-( retrying... #{Thread.current[:attempts]} exception: #{e.inspect}"
          puts str
          Thread.current[:attempts] == 10 ? raise(e) : retry
        end
      }
    }
    p MediaElement.order(:id).pluck(:id)
  end

  def lessons!
    Lesson.destroy_all
    # not_saved_records = {}
    EnhancedThread.join *csv_open.each.each_with_index.map { |row, i|
      proc {
        progress(i)
        begin
          # p 'a'
          record = csv_row_to_record(row)
          record.skip_public_validations = true
          record.skip_cover_creation     = true
          record.tags                    = tags(record.id, 'Lesson')
          # until Lesson.find_by_id record.parent_id
          #   p record.parent
          #   p record.parent_id
          #   p "record #{record.id}: sleeping..."
          #   sleep 0.1
          # end if record.parent_id
          # p 'b'
          record.save!
          # p 'c'
        rescue ActiveRecord::StatementInvalid, Errno::ENOENT => e
          Thread.current[:attempts] ||= 0
          Thread.current[:attempts] += 1
          p ":-( retrying... #{Thread.current[:attempts]}"
          Thread.current[:attempts] == 10 ? raise(e) : retry
        end
        # rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordInvalid => e
        #   p "exception: #{e.class}"
        #   not_saved_records[Thread.current.object_id] = e.record.id
        #   p 'd'
        # end
      }
    }
  end

  def slides!
    EnhancedThread.join *csv_open.each.each_with_index.map { |row, i|
      proc {
        progress(i)
        csv_row_to_record(row).save!
      }
    }
  end

  def media_elements_slides!
    MediaElementsSlide.destroy_all
    EnhancedThread.join *csv_open.each.each_with_index.map { |row, i|
      proc {
        progress(i)
        begin
          csv_row_to_record(row).save!
        rescue => e
          if r = e.record
            p r.media_element_id
            p MediaElement.find_by_id(r.media_element_id)
          end
          raise e
        end
      }
    }
  end

  def likes!
    EnhancedThread.join *csv_open.each.each_with_index.map { |row, i|
      proc {
        progress(i)
        csv_row_to_record(row).save!
      }
    }
  end

  def bookmarks!
    EnhancedThread.join *csv_open.each.each_with_index.map { |row, i|
      proc {
        progress(i)
        csv_row_to_record(row).save!
      }
    }
  end

end

Seeding.new.run
