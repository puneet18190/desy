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
User.create_user(CONFIG['admin_email'], user_name, user_surname, 'School', SchoolLevel.first.id, Location.first.id, subject_ids)

begin
  require Rails.root.join("db/seeds/environments", Rails.env)
rescue LoadError
end
