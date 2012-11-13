# encoding: UTF-8

location1 = Location.create :description => 'Nanjing' # qui va sostituito dalle città vere, prese da qualche file esterno
location2 = Location.create :description => 'Shanghai' # qui va sostituito dalle città vere, prese da qualche file esterno
location3 = Location.create :description => 'Beijing' # qui va sostituito dalle città vere, prese da qualche file esterno

school_level1 = SchoolLevel.create :description => 'Elementare' # idem
school_level2 = SchoolLevel.create :description => 'Medie' # idem
school_level3 = SchoolLevel.create :description => 'Liceo' # idem


subject1 = Subject.create :description => 'Curiosità' # idem
subject2 = Subject.create :description => 'Animali' # idem
subject3 = Subject.create :description => 'Scienze' # idem


User.create_user CONFIG['admin_email'], 'DESY', 'Admin User', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]

required = true

begin
  require Rails.root.join('script/development_seeds.rb')
rescue LoadError
  required = false
end

if Rails.env.development? && required
  plant_development_seeds
end

puts "Created #{Subject.count} subjects, #{Location.count} locations, #{SchoolLevel.count} school_levels, #{User.count} users, #{UsersSubject.count} users_subjects, #{Lesson.count} lessons, #{MediaElement.count} media_elements, #{Slide.count} slides, #{Notification.count} notifications, #{Like.count} likes, #{Bookmark.where(:bookmarkable_type => 'Lesson').count} bookmarks for lessons, #{Bookmark.where(:bookmarkable_type => 'MediaElement').count} bookmarks for media elements, #{Tag.count} tags, #{Tagging.count} taggings"
