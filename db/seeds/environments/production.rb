require 'csv'

csv_dir = Rails.root.join('db/seeds/environments/production/csv')

ActiveRecord::Base.transaction do

  puts 'locations...'
  records = csv_dir.join 'locations.csv'
  CSV.foreach(records, headers: true) do |row|
    Location.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end

  puts 'school levels...'
  records = csv_dir.join 'school_levels.csv'
  CSV.foreach(records, headers: true) do |row|
    SchoolLevel.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end

  puts 'subjects...'
  records = csv_dir.join 'subjects.csv'
  CSV.foreach(records, headers: true) do |row|
    Subject.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end

  user_subjects = ->(id) do
    CSV.open(csv_dir.join('users_subjects.csv'), headers: true).each.select do |row|
      row['user_id'] == id.to_s
    end.map do |row|
      row['subject_id']
    end
  end

  puts 'users...'
  records = csv_dir.join 'users.csv'
  CSV.foreach(records, headers: true) do |row|
    User.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
      record.subject_ids = user_subjects.call(record.id)
      record.accept_policies
    end.save!
  end

  puts 'tags...'
  records = csv_dir.join 'tags.csv'
  CSV.foreach(records, headers: true) do |row|
    Tag.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end


  audios_dir = Rails.root.join 'db/seeds/environments/production/media_elements/audios'
  videos_dir = Rails.root.join 'db/seeds/environments/production/media_elements/videos'
  images_dir = Rails.root.join 'db/seeds/environments/production/media_elements/images'
  image_extensions_glob = Image::EXTENSION_WHITE_LIST.map{ |str| str.chars.map{ |c| "[#{c}#{c.upcase}]" }.join('') }.join(',')

  audio = ->(id) do 
    v = Pathname.glob(audios_dir.join id.to_s, '*.mp3').first
    { mp3: v.to_s, ogg: v.sub(/\.mp3$/, '.ogg').to_s, filename: v.basename(v.extname).to_s }
  end

  video = ->(id) do 
    v = Pathname.glob(videos_dir.join id.to_s, '*.mp4').first
    { mp4: v.to_s, webm: v.sub(/\.mp4$/, '.webm').to_s, filename: v.basename(v.extname).to_s }
  end

  image = ->(id) do
    Pathname.glob(images_dir.join(id.to_s, "*.{#{image_extensions_glob}}")).first
  end

  tags = ->(id, type) do
    CSV.open(csv_dir.join('taggings.csv'), headers: true).each.select do |row|
      row['taggable_type'] == type && row['taggable_id'] == id.to_s
    end.map do |row|
      Tag.find row['tag_id']
    end
  end

  puts 'media_elements...'
  records = csv_dir.join 'media_elements.csv'
  CSV.foreach(records, headers: true) do |row|
    record = 
      case row['sti_type']
      when 'Audio'
        Audio.new do |record|
          row.headers.each do |header|
            record.send :"#{header}=", row[header]
          end
          record.media = audio.call(record.id)
        end
      when 'Video'
        Video.new do |record|
          row.headers.each do |header|
            record.send :"#{header}=", row[header]
          end
          record.media = video.call(record.id)
        end
      when 'Image'
        Image.new do |record|
          row.headers.each do |header|
            record.send :"#{header}=", row[header]
          end
          record.media = File.open(image.call(record.id))
        end
      else raise "unknown media element type; row: #{row}"
      end
    record.skip_public_validations = true
    record.tags = tags.call(record.id, 'MediaElement')
    record.save!
  end

  puts 'lessons...'
  records = csv_dir.join 'lessons.csv'
  CSV.foreach(records, headers: true) do |row|
    Lesson.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
      record.skip_public_validations = true
      record.skip_cover_creation = true
      record.tags = tags.call(record.id, 'Lesson')
    end.save!
  end

  puts 'slides...'
  records = csv_dir.join 'slides.csv'
  puts Slide.all
  CSV.foreach(records, headers: true) do |row|
    Slide.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end

  puts 'media elements slides...'
  records = csv_dir.join 'media_elements_slides.csv'
  CSV.foreach(records, headers: true) do |row|
    MediaElementsSlide.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end

  puts 'likes...'
  records = csv_dir.join 'likes.csv'
  CSV.foreach(records, headers: true) do |row|
    Like.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end

  puts 'bookmarks...'
  records = csv_dir.join 'bookmarks.csv'
  CSV.foreach(records, headers: true) do |row|
    Bookmark.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end

end

# TODO fare che le tags se le creano i media_elements e le lezioni
#      spostare i csv in un posto consono