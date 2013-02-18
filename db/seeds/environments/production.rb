require 'csv'

csv_dir = Rails.root.join('db/seeds/environments/production/csv')

csv_options = { headers: true }

ActiveRecord::Base.transaction do

  puts 'Locations...'
  records = csv_dir.join 'locations.csv'
  CSV.foreach(records, csv_options) do |row|
    Location.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end

  puts 'School levels...'
  records = csv_dir.join 'school_levels.csv'
  CSV.foreach(records, csv_options) do |row|
    SchoolLevel.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end

  puts 'Subjects...'
  records = csv_dir.join 'subjects.csv'
  CSV.foreach(records, csv_options) do |row|
    Subject.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end

  user_subjects = ->(id) do
    CSV.open(csv_dir.join('users_subjects.csv'), csv_options).each.select do |row|
      row['user_id'] == id.to_s
    end.map do |row|
      row['subject_id']
    end
  end

  puts 'Users...'
  records = csv_dir.join 'users.csv'
  CSV.foreach(records, csv_options) do |row|
    User.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
      record.subject_ids = user_subjects.call(record.id)
      record.accept_policies
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
    CSV.open(csv_dir.join('taggings.csv'), csv_options).each.select do |row|
      row['taggable_type'] == type && row['taggable_id'] == id.to_s
    end.map do |taggable_row|
      CSV.open(csv_dir.join('tags.csv'), csv_options).each.
        detect{ |tags_row| taggable_row['tag_id'] == tags_row['id'] }['word']
    end.join(',')
  end

  puts 'Media elements...'
  records = csv_dir.join 'media_elements.csv'
  CSV.foreach(records, csv_options) do |row|
    record =
      row['sti_type'].constantize.new do |record|
        row.headers.each do |header|
          record.send :"#{header}=", row[header]
        end
      end
    record.media = 
      case record
      when Audio
        audio.call(record.id)
      when Video
        video.call(record.id)
      when Image
        File.open(image.call(record.id))
      else raise "wrong media element type; row: #{row}"
      end
    record.skip_public_validations = true
    record.tags = tags.call(record.id, 'MediaElement')
    record.save!
  end

  puts 'Lessons...'
  records = csv_dir.join 'lessons.csv'
  CSV.foreach(records, csv_options) do |row|
    Lesson.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
      record.skip_public_validations = true
      record.skip_cover_creation = true
      record.tags = tags.call(record.id, 'Lesson')
    end.save!
  end

  puts 'Slides...'
  records = csv_dir.join 'slides.csv'
  puts Slide.all
  CSV.foreach(records, csv_options) do |row|
    Slide.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end

  puts 'Media elements slides...'
  records = csv_dir.join 'media_elements_slides.csv'
  CSV.foreach(records, csv_options) do |row|
    MediaElementsSlide.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end

  puts 'Likes...'
  records = csv_dir.join 'likes.csv'
  CSV.foreach(records, csv_options) do |row|
    Like.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end

  puts 'Bookmarks...'
  records = csv_dir.join 'bookmarks.csv'
  CSV.foreach(records, csv_options) do |row|
    Bookmark.new do |record|
      row.headers.each do |header|
        record.send :"#{header}=", row[header]
      end
    end.save!
  end

end

puts 'Fine.'
