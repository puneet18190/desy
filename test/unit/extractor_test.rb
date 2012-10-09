require 'test_helper'

class ExtractorTest < ActiveSupport::TestCase
  
  test 'suggested_lessons' do
    user = User.find 1
    assert user.edit_fields 'a_name', 'a_surname', 'a_school', user.school_level_id, user.location_id, [1, 2, 3, 4, 5, 6]
    user2 = User.find 2
    assert user2.edit_fields 'a_name', 'a_surname', 'a_school', user2.school_level_id, user2.location_id, [1, 2, 3, 4]
    les1 = user.create_lesson('title1', 'desc1', 1)
    les2 = user.create_lesson('title2', 'desc2', 2)
    les3 = user.create_lesson('title3', 'desc3', 3)
    les4 = user.create_lesson('title4', 'desc4', 4)
    les5 = user.create_lesson('title5', 'desc5', 5)
    les6 = user.create_lesson('title6', 'desc6', 6)
    les7 = user.create_lesson('title7', 'desc7', 1)
    les8 = user.create_lesson('title8', 'desc8', 2)
    les9 = user.create_lesson('title9', 'desc9', 3)
    assert_equal 11, Lesson.count, "Error, a lesson was not saved -- {les1 => #{les1.inspect}, les2 => #{les2.inspect}, les3 => #{les3.inspect}, les4 => #{les4.inspect}, les5 => #{les5.inspect}, les6 => #{les6.inspect}, les7 => #{les7.inspect}, les8 => #{les8.inspect}, les9 => #{les9.inspect},}"
    assert les1.publish
    assert les2.publish
    assert les3.publish
    assert les4.publish
    assert les5.publish
    assert les6.publish
    l = Lesson.find 2
    assert_equal 2, l.user_id
    assert_equal true, l.is_public
    resp = user2.suggested_lessons(6)
    ids = []
    resp.each do |ll|
      ids << ll.id
    end
    my_ids = [les1.id, les2.id, les3.id, les4.id]
    assert_equal ids.sort, my_ids.sort
  end
  
end
