location = Location.create :description => 'admin' # qui va sostituito dalle città vere, prese da qualche file esterno

school_level = SchoolLevel.create :description => 'admin' # idem

subject = Subject.create :description => 'admin' # idem

User.create_user CONFIG['admin_email'], 'DESY', 'Admin User', 'School', school_level.id, location.id, [subject.id]
