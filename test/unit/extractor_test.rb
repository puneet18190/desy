require 'test_helper'

class ExtractorTest < ActiveSupport::TestCase
  
  def setup
    @user1 = User.find 1
    assert @user1.edit_fields 'a_name', 'a_surname', 'a_school', @user1.school_level_id, @user1.location_id, [1, 2, 3, 4, 5, 6]
    @user2 = User.find 2
    assert @user2.edit_fields 'a_name', 'a_surname', 'a_school', @user2.school_level_id, @user2.location_id, [1, 2, 3, 4]
    # LESSONS
    @les1 = @user1.create_lesson('title1', 'desc1', 1)
    @les2 = @user1.create_lesson('title2', 'desc2', 2)
    @les3 = @user1.create_lesson('title3', 'desc3', 3)
    @les4 = @user1.create_lesson('title4', 'desc4', 4)
    @les5 = @user1.create_lesson('title5', 'desc5', 5)
    @les6 = @user1.create_lesson('title6', 'desc6', 6)
    @les7 = @user1.create_lesson('title7', 'desc7', 1)
    @les8 = @user1.create_lesson('title8', 'desc8', 2)
    @les9 = @user1.create_lesson('title9', 'desc9', 3)
    assert_equal 11, Lesson.count, "Error, a lesson was not saved -- {les1 => #{@les1.inspect}, les2 => #{@les2.inspect}, les3 => #{@les3.inspect}, les4 => #{@les4.inspect}, les5 => #{@les5.inspect}, les6 => #{@les6.inspect}, les7 => #{@les7.inspect}, les8 => #{@les8.inspect}, les9 => #{@les9.inspect},}"
    assert @les1.publish
    assert @les2.publish
    assert @les3.publish
    assert @les4.publish
    assert @les5.publish
    assert @les6.publish
    # MEDIA ELEMENTS
    @el1 = MediaElement.new :description => 'desc1', :title => 'titl1'
    @el1.user_id = 1
    @el1.sti_type = 'Video'
    @el1.duration = 10
    assert_obj_saved @el1
    @el2 = MediaElement.new :description => 'desc2', :title => 'titl2'
    @el2.user_id = 1
    @el2.sti_type = 'Video'
    @el2.duration = 10
    assert_obj_saved @el2
    @el3 = MediaElement.new :description => 'desc3', :title => 'titl3'
    @el3.user_id = 1
    @el3.sti_type = 'Audio'
    @el3.duration = 10
    assert_obj_saved @el3
    @el4 = MediaElement.new :description => 'desc4', :title => 'titl4'
    @el4.user_id = 1
    @el4.sti_type = 'Audio'
    @el4.duration = 10
    assert_obj_saved @el4
    @el5 = MediaElement.new :description => 'desc5', :title => 'titl5'
    @el5.user_id = 1
    @el5.sti_type = 'Image'
    assert_obj_saved @el5
    @el6 = MediaElement.new :description => 'desc6', :title => 'titl6'
    @el6.user_id = 1
    @el6.sti_type = 'Image'
    assert_obj_saved @el6
    @el7 = MediaElement.new :description => 'desc7', :title => 'titl7'
    @el7.user_id = 1
    @el7.sti_type = 'Image'
    assert_obj_saved @el7
    @el1.is_public = true
    @el1.publication_date = '2012-01-01 10:00:00'
    assert_obj_saved @el1
    @el2.is_public = true
    @el2.publication_date = '2012-01-01 10:00:00'
    assert_obj_saved @el2
    @el3.is_public = true
    @el3.publication_date = '2012-01-01 10:00:00'
    assert_obj_saved @el3
    @el5.is_public = true
    @el5.publication_date = '2012-01-01 10:00:00'
    assert_obj_saved @el5
    @el7.is_public = true
    @el7.publication_date = '2012-01-01 10:00:00'
    assert_obj_saved @el7
  end
  
  test 'suggested_lessons' do
    l = Lesson.find 2
    assert_equal 2, l.user_id
    assert_equal true, l.is_public
    resp = @user2.suggested_lessons(6)
    ids = []
    resp.each do |ll|
      ids << ll.id
    end
    my_ids = [@les1.id, @les2.id, @les3.id, @les4.id]
    assert_equal ids.sort, my_ids.sort
  end
  
  test 'suggested_elements' do
    assert @user2.bookmark 'MediaElement', @el3.id
    my_ids = [2, 4, @el1.id, @el2.id, @el3.id, @el5.id, @el7.id]
    resp = @user2.suggested_elements 80
    ids = []
    resp.each do |r|
      ids << r.id
    end
    assert_equal ids.sort, my_ids.sort
  end
  
  test 'own_lessons' do
    assert Lesson.find(1).publish
    el = MediaElement.find(1)
    el.is_public = true
    el.publication_date = '2011-11-11 10:00:00'
    assert_obj_saved el
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    assert @user2.bookmark 'MediaElement', 1
    resp = @user2.own_lessons(1, 20)
    ids = []
    resp.each do |r|
      ids << r.id
    end
    my_ids = [1, 2, @les2.id, @les5.id, @les6.id]
    assert_equal ids.sort, my_ids.sort
  end
  
  test 'own_media_elements' do
    assert @user2.bookmark 'MediaElement', 2
    assert @user2.bookmark 'MediaElement', @el2.id
    assert @user2.bookmark 'MediaElement', @el5.id
    assert_extractor [2, 3, 4, 6, @el2.id, @el5.id], @user2.own_media_elements(1, 20)
  end
  
  test 'own_lessons_filter_private' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3)
    assert Lesson.exists?(les10.id)
    assert_extractor [les10.id], @user2.own_lessons(1, 20, 'Private')
  end
  
  test 'own_lessons_filter_public' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3)
    assert Lesson.exists?(les10.id)
    assert_extractor [1, 2, @les2.id, @les5.id, @les6.id], @user2.own_lessons(1, 20, 'Public')
  end
  
  test 'own_lessons_filter_linked' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3)
    assert Lesson.exists?(les10.id)
    assert_extractor [1, @les2.id, @les5.id, @les6.id], @user2.own_lessons(1, 20, 'Linked')
  end
  
  test 'own_lessons_filter_only_mine' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3)
    assert Lesson.exists?(les10.id)
    assert_extractor [2, les10.id], @user2.own_lessons(1, 20, 'Your own')
  end
  
  test 'own_lessons_filter_copied' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3)
    assert Lesson.exists?(les10.id)
    les11 = les10.copy(@user2.id)
    assert Lesson.exists?(les11.id)
    les12 = Lesson.find(1).copy(@user2.id)
    assert Lesson.exists?(les12.id)
    les13 = @les5.copy(@user2.id)
    assert Lesson.exists?(les13.id)
    assert_extractor [les11.id, les12.id, les13.id], @user2.own_lessons(1, 20, 'Just copied')
  end
  
  test 'offset' do
    resp = @user1.own_lessons(1, 4)
    assert_equal 4, resp.length
    resptemp = @user1.own_lessons(2, 4)
    assert_equal 4, resptemp.length
    resptemp.each do |rt|
      flag = true
      resp.each do |r|
        flag = false if r.id == rt.id
      end
      assert flag
    end
    resp += resptemp
    
  end
  
end
