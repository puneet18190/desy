location = Location.create :description => 'admin' # qui va sostituito dalle città vere, prese da qualche file esterno

school_level = SchoolLevel.create :description => 'admin' # idem

user = User.new :name => 'DESY', :surname => 'Admin User', :school_level_id => school_level.id, :school => 'School', :location_id => location.id
user.email = VARIABLES['admin_email']

user.save
