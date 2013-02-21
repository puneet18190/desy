require 'csv'

class Seeding
  CSV_DIR     = Rails.root.join("db/seeds/environments/#{Rails.env}/csv")
  CSV_OPTIONS = { headers: true }

  PUBLIC_MEDIA_ELEMENTS_FOLDER     = Media::Uploader::MEDIA_ELEMENTS_FOLDER
  OLD_PUBLIC_MEDIA_ELEMENTS_FOLDER = "#{PUBLIC_MEDIA_ELEMENTS_FOLDER}.old"

  MEDIA_ELEMENTS_FOLDER = Rails.root.join "db/seeds/environments/#{Rails.env}/media_elements"
  AUDIOS_FOLDER         = MEDIA_ELEMENTS_FOLDER.join 'audios'
  VIDEOS_FOLDER         = MEDIA_ELEMENTS_FOLDER.join 'videos'
  IMAGES_FOLDER         = MEDIA_ELEMENTS_FOLDER.join 'images'

  VIDEOS_PLACEHOLDERS_FOLDER = VIDEOS_FOLDER.join 'placeholder'

  IMAGE_EXTENSIONS_GLOB = Image::EXTENSION_WHITE_LIST.map do |str| 
    str.chars.map{ |c| "[#{c}#{c.upcase}]" }.join('')
  end.join(',')

  def run
    puts "Applying #{Rails.env} seeds"

    FileUtils.rm_rf OLD_PUBLIC_MEDIA_ELEMENTS_FOLDER
    begin
      FileUtils.mv PUBLIC_MEDIA_ELEMENTS_FOLDER, OLD_PUBLIC_MEDIA_ELEMENTS_FOLDER
    rescue Errno::ENOENT
    end

    ActiveRecord::Base.transaction do
      locations!
      school_levels!
      subjects!
      users!
      media_elements!
      lessons!
      slides!
      media_elements_slides!
      likes!
      bookmarks!

      FileUtils.cp_r VIDEOS_PLACEHOLDERS_FOLDER, Media::Video::Placeholder::ABSOLUTE_FOLDER
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

  def csv_path(filename)
    CSV_DIR.join "#{filename}.csv"
  end

  def user_subjects(id)
    CSV.open(csv_path('users_subjects'), CSV_OPTIONS).each.select do |row|
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
      File.open Pathname.glob(IMAGES_FOLDER.join(record.id.to_s, "*.{#{IMAGE_EXTENSIONS_GLOB}}")).first
    else raise 'wrong media element type'
    end
  end

  def tags(id, type)
    CSV.open(csv_path('taggings'), CSV_OPTIONS).each.select do |row|
      row['taggable_type'] == type && row['taggable_id'] == id.to_s
    end.map do |taggable_row|
      CSV.open(csv_path('tags'), CSV_OPTIONS).each.
        detect{ |tags_row| taggable_row['tag_id'] == tags_row['id'] }['word']
    end.join(',')
  end

  def csv_row_to_record(model, row)
    model.new do |record|
      row.headers.each { |header| record.send :"#{header}=", row[header] }
    end
  end

  def update_sequence(model)
    model.connection.reset_pk_sequence! model.table_name
  end

  def locations!
    model = Location
    puts 'locations...'
    CSV.foreach(csv_path('locations'), CSV_OPTIONS) do |row|
      csv_row_to_record(model, row).save!
    end
    update_sequence model
  end

  def school_levels!
    model = SchoolLevel
    puts 'school levels...'
    CSV.foreach(csv_path('school_levels'), CSV_OPTIONS) do |row|
      csv_row_to_record(model, row).save!
    end
    update_sequence model
  end

  def subjects!
    model = Subject
    puts 'subjects...'
    CSV.foreach(csv_path('subjects'), CSV_OPTIONS) do |row|
      csv_row_to_record(model, row).save!
    end
    update_sequence model
  end

  def users!
    model = User
    puts 'users...'
    CSV.foreach(csv_path('users'), CSV_OPTIONS) do |row|
      record = csv_row_to_record(model, row)
      record.subject_ids = user_subjects(record.id)
      record.accept_policies
      record.save!
    end
    update_sequence model
  end

  def media_elements!
    model = MediaElement
    puts 'media elements...'
    CSV.foreach(csv_path('media_elements'), CSV_OPTIONS) do |row|
      record = csv_row_to_record(row['sti_type'].constantize, row)
      record.media                   = media(record)
      record.skip_public_validations = true
      record.tags                    = tags(record.id, 'MediaElement')
      record.save!
    end
    update_sequence model
  end

  def lessons!
    model = Lesson
    puts 'lessons...'
    CSV.foreach(csv_path('lessons'), CSV_OPTIONS) do |row|
      record = csv_row_to_record(model, row)
      record.skip_public_validations = true
      record.skip_cover_creation     = true
      record.tags                    = tags(record.id, 'Lesson')
      record.save!
    end
    update_sequence model
  end

  def slides!
    model = Slide
    puts 'slides...'
    CSV.foreach(csv_path('slides'), CSV_OPTIONS) do |row|
      csv_row_to_record(model, row).save!
    end
    update_sequence model
  end

  def media_elements_slides!
    model = MediaElementsSlide
    puts 'media elements slides...'
    CSV.foreach(csv_path('media_elements_slides'), CSV_OPTIONS) do |row|
      csv_row_to_record(model, row).save!
    end
    update_sequence model
  end

  def likes!
    model = Like
    puts 'likes...'
    CSV.foreach(csv_path('likes'), CSV_OPTIONS) do |row|
      csv_row_to_record(model, row).save!
    end
    update_sequence model
  end

  def bookmarks!
    model = Bookmark
    puts 'bookmarks...'
    CSV.foreach(csv_path('bookmarks'), CSV_OPTIONS) do |row|
      csv_row_to_record(model, row).save!
    end
    update_sequence model
  end

end

Seeding.new.run
