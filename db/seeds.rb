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

puts "Created:"
puts "#{Subject.count} subjects (should be 3)"
puts "#{Location.count} locations (should be 3)"
puts "#{SchoolLevel.count} school_levels (should be 3)"
puts "#{User.count} users (should be 18)"
puts "#{UsersSubject.count} users_subjects (should be 54)"
puts "#{Lesson.count} lessons (should be 43)"
puts "#{MediaElement.count} media_elements (should be 70)"
puts "#{Slide.count} slides (should be 73)"
puts "#{Notification.count} notifications (should be 42)"
puts "#{Like.count} likes (should be 122)"
puts "#{Bookmark.where(:bookmarkable_type => 'Lesson').count} bookmarks for lessons (should be 12)"
puts "#{Bookmark.where(:bookmarkable_type => 'MediaElement').count} bookmarks for media elements (should be 17)"
puts "#{Tag.count} tags (should be 34)"
puts "#{Tagging.count} taggings (should be 791)"
