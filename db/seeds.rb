def create_locations_school_levels_subjects_admin_user
  
  Location.seed!

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

  User.confirmed.new(password:              SETTINGS['admin']['password'], 
                     password_confirmation: SETTINGS['admin']['password'], 
                     name:                  SETTINGS['admin']['name'], 
                     surname:               SETTINGS['admin']['surname'], 
                     school_level_id:       SchoolLevel.first.id, 
                     location_id:           User.location_association_class.first.id,
                     subject_ids:           subject_ids) do |user|
    user.email = SETTINGS['admin']['email']
    user.accept_policies
  end.save!

end

begin
  require Rails.root.join("db/seeds/environments", Rails.env)
rescue LoadError
end
