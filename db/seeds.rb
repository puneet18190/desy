# encoding: UTF-8

CONFIG['locations'].each do |l|
  location = Location.new :description => l
  location.save!
end

CONFIG['school_levels'].each do |sl|
  school_level = SchoolLevel.new :description => sl
  school_level.save!
end

subject_ids = []
CONFIG['subjects'].each do |s|
  subject = Subject.new :description => s
  subject.save!
  subject_ids << subject.id
end

user_name = CONFIG['admin_username'].split(' ').first
user_surname = CONFIG['admin_username'].gsub("#{user_name} ", '')
raise 'could not create admin user' if !User.create_user(CONFIG['admin_email'], user_name, user_surname, 'School', SchoolLevel.first.id, Location.first.id, subject_ids)

required = true


if Rails.env.development?
  require Rails.root.join('db/seeds/environments/development')
  plant_development_seeds
  puts "Created:"
  puts "#{Subject.count} subjects (should be 5)"
  puts "#{Location.count} locations (should be 6)"
  puts "#{SchoolLevel.count} school_levels (should be 4)"
  puts "#{User.count} users (should be 18)"
  puts "#{UsersSubject.count} users_subjects (should be 54)"
  puts "#{Lesson.count} lessons (should be 43)"
  puts "#{MediaElement.count} media_elements (should be 70)"
  puts " - #{Image.count} images (should be 32)"
  puts " - #{Audio.count} audios (should be 19)"
  puts " - #{Video.count} videos (should be 19)"
  puts "#{Audio.count} audios (should be 19)"
  puts "#{Image.count} images (should be 32)"
  puts "#{Video.count} videos (should be 19)"
  puts "#{Slide.count} slides (should be 125)"
  puts "#{Notification.count} notifications (should be 43)"
  puts "#{Like.count} likes (should be 122)"
  puts "#{Bookmark.where(:bookmarkable_type => 'Lesson').count} bookmarks for lessons (should be 12)"
  puts "#{Bookmark.where(:bookmarkable_type => 'MediaElement').count} bookmarks for media elements (should be 17)"
  puts "#{Tag.count} tags (should be 34)"
  puts "#{Tagging.count} taggings (should be 791)"

  begin
    require 'colorize'
    puts 'FINE'.green
  rescue LoadError
  end

end
