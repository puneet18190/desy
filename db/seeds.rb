def create_locations_school_levels_subjects_admin_user
  SETTINGS['locations'].each do |l|
    location = Location.new :description => l
    location.save!
  end

  SETTINGS['school_levels'].each do |sl|
    school_level = SchoolLevel.new :description => sl
    school_level.save!
  end

  subject_ids = []
  SETTINGS['subjects'].each do |s|
    subject = Subject.new :description => s
    subject.save!
    subject_ids << subject.id
  end

  user_name = SETTINGS['admin_username'].split(' ').first
  user_surname = SETTINGS['admin_username'].gsub("#{user_name} ", '')
  User.create_user(SETTINGS['admin_email'], 'password', 'password', user_name, user_surname, 'School', SchoolLevel.first.id, Location.first.id, subject_ids, true)
end

begin
  require Rails.root.join("db/seeds/environments", Rails.env)
rescue LoadError
end
