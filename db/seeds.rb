require 'csv'
require 'env_relative_path'

class Seeding
  include EnvRelativePath

  CSV_DIR     = Rails.root.join("db/seeds/environments/#{Rails.env}/csv")
  CSV_OPTIONS = { headers: true }

  PUBLIC_MEDIA_ELEMENTS_FOLDER     = Media::Uploader::MEDIA_ELEMENTS_FOLDER
  OLD_PUBLIC_MEDIA_ELEMENTS_FOLDER = "#{PUBLIC_MEDIA_ELEMENTS_FOLDER}.old"

  MEDIA_ELEMENTS_FOLDER = Rails.root.join "db/seeds/environments/#{Rails.env}/media_elements"
  # AUDIOS_FOLDER, VIDEOS_FOLDER, IMAGES_FOLDER
  %w(audios videos images).each do |media_folder|
    const_set :"#{media_folder.upcase}_FOLDER", Pathname.new(env_relative_path MEDIA_ELEMENTS_FOLDER, media_folder)
  end

  MODELS = [ Location, SchoolLevel, Subject, User, MediaElement, Lesson, Slide, MediaElementsSlide, Like, Bookmark ]

  def run
    puts "Applying #{Rails.env} seeds (#{MODELS.map{ |m| humanize_table_name(m.table_name) }.join(', ')})"

    FileUtils.rm_rf OLD_PUBLIC_MEDIA_ELEMENTS_FOLDER
    begin
      FileUtils.mv PUBLIC_MEDIA_ELEMENTS_FOLDER, OLD_PUBLIC_MEDIA_ELEMENTS_FOLDER
    rescue Errno::ENOENT
    end

    ActiveRecord::Base.transaction do
      MODELS.each do |model|
        @model, @table_name = model, model.table_name
        set_rows_amount
        send :"#{@table_name}!"
        update_sequence
      end

      FileUtils.rm_rf OLD_PUBLIC_MEDIA_ELEMENTS_FOLDER
    end

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
    csv_open(csv_path('users_subjects')).each.select do |row|
      row['user_id'] == id.to_s
    end.map do |row|
      row['subject_id']
    end
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
    model.new do |record|
      row.headers.each { |header| record.send :"#{header}=", row[header] }
    end
  end

  def update_sequence
    @model.connection.reset_pk_sequence! @table_name
  end

  def progress(i)
    n = i+1

    $stdout.print "  saving #{n.ordinalize} of #{@rows_amount} #{humanize_table_name}\r"
    $stdout.flush

    return if n != @rows_amount

    $stdout.puts
    $stdout.flush
  end

  def set_rows_amount
    @rows_amount = csv_open.readlines.count
  end

  def locations!
    csv_open.each.each_with_index do |row, i|
      progress(i)
      csv_row_to_record(row).save!
    end
  end

  def school_levels!
    csv_open.each.each_with_index do |row, i|
      progress(i)
      csv_row_to_record(row).save!
    end
  end

  def subjects!
    csv_open.each.each_with_index do |row, i|
      progress(i)
      csv_row_to_record(row).save!
    end
  end

  def users!
    csv_open.each.each_with_index do |row, i|
      progress(i)
      record = csv_row_to_record(row)
      record.subject_ids = users_subjects(record.id)
      record.accept_policies
      record.save!
    end
  end

  def media_elements!
    csv_open.each.each_with_index do |row, i|
      progress(i)
      record = csv_row_to_record(row, row['sti_type'].constantize)
      record.media                   = media(record)
      record.skip_public_validations = true
      record.tags                    = tags(record.id, 'MediaElement')
      record.save!
    end
  end

  def lessons!
    csv_open.each.each_with_index do |row, i|
      progress(i)
      record = csv_row_to_record(row)
      record.skip_public_validations = true
      record.skip_cover_creation     = true
      record.tags                    = tags(record.id, 'Lesson')
      record.save!
    end
  end

  def slides!
    csv_open.each.each_with_index do |row, i|
      progress(i)
      csv_row_to_record(row).save!
    end
  end

  def media_elements_slides!
    csv_open.each.each_with_index do |row, i|
      progress(i)
      csv_row_to_record(row).save!
    end
  end

  def likes!
    csv_open.each.each_with_index do |row, i|
      progress(i)
      csv_row_to_record(row).save!
    end
  end

  def bookmarks!
    csv_open.each.each_with_index do |row, i|
      progress(i)
      csv_row_to_record(row).save!
    end
  end

end

Seeding.new.run
