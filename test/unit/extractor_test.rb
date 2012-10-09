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
  
  test 'suggested_elements' do
    el1 = MediaElement.new :description => 'desc1', :title => 'titl1'
    el1.user_id = 1
    el1.sti_type = 'Video'
    el1.duration = 10
    assert_obj_saved el1
    el2 = MediaElement.new :description => 'desc2', :title => 'titl2'
    el2.user_id = 1
    el2.sti_type = 'Video'
    el2.duration = 10
    assert_obj_saved el2
    el3 = MediaElement.new :description => 'desc3', :title => 'titl3'
    el3.user_id = 1
    el3.sti_type = 'Audio'
    el3.duration = 10
    assert_obj_saved el3
    el4 = MediaElement.new :description => 'desc4', :title => 'titl4'
    el4.user_id = 1
    el4.sti_type = 'Audio'
    el4.duration = 10
    assert_obj_saved el4
    el5 = MediaElement.new :description => 'desc5', :title => 'titl5'
    el5.user_id = 1
    el5.sti_type = 'Image'
    assert_obj_saved el5
    el6 = MediaElement.new :description => 'desc6', :title => 'titl6'
    el6.user_id = 1
    el6.sti_type = 'Image'
    assert_obj_saved el6
    el7 = MediaElement.new :description => 'desc7', :title => 'titl7'
    el7.user_id = 1
    el7.sti_type = 'Image'
    assert_obj_saved el7
    el1.is_public = true
    el1.publication_date = '2012-01-01 10:00:00'
    assert_obj_saved el1
    el2.is_public = true
    el2.publication_date = '2012-01-01 10:00:00'
    assert_obj_saved el2
    el3.is_public = true
    el3.publication_date = '2012-01-01 10:00:00'
    assert_obj_saved el3
    el5.is_public = true
    el5.publication_date = '2012-01-01 10:00:00'
    assert_obj_saved el5
    el7.is_public = true
    el7.publication_date = '2012-01-01 10:00:00'
    assert_obj_saved el7
    uu = User.find 2
    assert uu.bookmark 'MediaElement', el3.id
    my_ids = [2, el1.id, el2.id, el5.id, el7.id]
    resp = uu.suggested_elements 6
    ids = []
    resp.each do |r|
      ids << r.id
    end
    assert_equal ids.sort, my_ids.sort
  end
  
end
