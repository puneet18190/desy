require 'test_helper'

class CoreMethodsTest < ActiveSupport::TestCase
  
  test 'destroy_users_with_dependencies' do
    uu = User.new
    assert !uu.destroy_with_dependencies
    assert_equal 1, uu.errors.messages[:base].length
    assert_match /The user could not be deleted/, uu.errors.messages[:base].first
    resp = User.confirmed.new(:password => SETTINGS['admin']['password'], :password_confirmation => SETTINGS['admin']['password'], :name => 'oo', :surname => 'fsg', :school_level_id => 1, :location_id => 1, :subject_ids => [1, 2]) do |user|
      user.email = SETTINGS['admin']['email']
    end
    resp.policy_1 = '1'
    resp.policy_2 = '1'
    resp.active = true
    assert resp.save, resp.errors.inspect
    assert !resp.nil?
    x = User.find 1
    lessons = Lesson.where(:user_id => 1)
    assert_equal 1, lessons.length
    assert_equal 1, lessons[0].id
    assert lessons[0].publish
    b = Bookmark.new
    b.user_id = 2
    b.bookmarkable_id = 1
    b.bookmarkable_type = 'Lesson'
    assert_obj_saved b
    assert_equal 1, Notification.where(:user_id => 2).count
    assert_equal 2, UsersSubject.where(:user_id => 1).count
    assert_equal 4, MediaElement.where(:user_id => 1).count
    assert_equal 2, Notification.where(:user_id => 1).count
    assert_equal 1, Bookmark.where(:user_id => 1).count
    assert_equal 1, Like.where(:user_id => 1).count
    assert_equal 2, Report.where(:user_id => 1).count
    assert x.destroy_with_dependencies
    assert Lesson.where(:user_id => 1).empty?
    assert UsersSubject.where(:user_id => 1).empty?
    assert MediaElement.where(:user_id => 1).empty?
    assert Notification.where(:user_id => 1).empty?
    assert Bookmark.where(:user_id => 1).empty?
    assert Like.where(:user_id => 1).empty?
    assert Report.where(:user_id => 1).empty?
    assert !User.exists?(1)
    assert_equal 2, MediaElement.where(:user_id => resp.id).length
    assert_equal 2, Notification.where(:user_id => 2).count
  end
  
  test 'copy_lesson' do
    assert Lesson.new.copy(1).nil?
    x = Lesson.find(1)
    assert x.copy(100).nil?
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The lesson could not be copied/, x.errors.messages[:base].first
    assert x.copy(2).nil?
    resp = x.copy(1)
    assert !resp.nil?
    assert x.copy(1).nil?
    assert_equal 1, x.errors.messages[:base].length
    assert_match /You already have a copy of this lesson/, x.errors.messages[:base].first
    x = Lesson.find(2)
    cccount_slides = x.slides.count
    assert x.add_slide('image2', cccount_slides + 1)
    new_slide_image2 = Slide.where(:lesson_id => x.id, :position => (cccount_slides + 1)).first
    assert !new_slide_image2.nil?
    mediaaa = MediaElementsSlide.new
    mediaaa.slide_id = new_slide_image2.id
    mediaaa.media_element_id = 6
    mediaaa.alignment = 3
    mediaaa.caption = 'ohlala'
    mediaaa.position = 2
    assert_obj_saved mediaaa
    resp = x.copy(1)
    assert !resp.nil?
    # I try to copy the copy
    assert resp.copy(1).nil?
    assert_equal 1, resp.errors.messages[:base].length
    assert_match /You've just copied this lesson/, resp.errors.messages[:base].first
    # until here
    assert_equal 1, resp.school_level_id
    assert_equal 3, resp.subject_id
    assert_equal 'string', resp.title
    assert_equal 'text', resp.description
    assert !resp.is_public
    assert resp.copied_not_modified
    s1 = Slide.where(:lesson_id => resp.id, :position => 1).first
    assert !s1.nil?
    s2 = Slide.where(:lesson_id => resp.id, :position => 2).first
    assert !s2.nil?
    assert_equal 'audio', s2.kind
    assert s2.title.blank?
    assert s2.text.blank?
    med1 = MediaElementsSlide.where(:slide_id => s2.id).first
    assert !med1.nil?
    assert_equal 4, med1.media_element_id
    s3 = Slide.where(:lesson_id => resp.id, :position => 3).first
    assert !s3.nil?
    assert_equal 'video1', s3.kind
    assert_equal 'Ciao', s3.title
    assert_equal 'beh... beh beh', s3.text
    med2 = MediaElementsSlide.where(:slide_id => s3.id).first
    assert !med2.nil?
    assert_equal 2, med2.media_element_id
    s4 = Slide.where(:lesson_id => resp.id, :position => 4).first
    assert !s4.nil?
    assert_equal 'image2', s4.kind
    assert s4.text.nil?
    assert s4.title.nil?
    assert_equal 1, MediaElementsSlide.where(:slide_id => s4.id).count
    meds = MediaElementsSlide.where(:slide_id => s4.id).first
    assert_equal 3, meds.alignment
    assert_equal 'ohlala', meds.caption
    assert_equal 6, meds.media_element_id
    assert_equal 2, meds.position
    assert_tags resp, ['squalo', 'cane', 'elefante', 'gatto']
  end
  
  test 'publish_lesson' do
    x = Lesson.new
    assert !x.publish
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The lesson could not be shared/, x.errors.messages[:base].first
    x = Lesson.find 2
    assert !x.publish
    assert_equal 1, x.errors.messages[:base].length
    assert_match /This lesson is already being shared/, x.errors.messages[:base].first
    x = Lesson.find 1
    new_slide = Slide.new :position => 2
    new_slide.lesson_id = 1
    new_slide.kind = 'image2'
    assert_obj_saved new_slide
    mes = MediaElementsSlide.new
    mes.slide_id = new_slide.id
    mes.media_element_id = 5
    mes.position = 2
    mes.alignment = -1
    mes.caption = 'sagdg'
    assert_obj_saved mes
    assert !MediaElementsSlide.find(mes.id).media_element.is_public
    assert Bookmark.where(:bookmarkable_type => 'MediaElement', :bookmarkable_id => MediaElementsSlide.find(mes.id).media_element_id).empty?
    assert x.publish
    assert Lesson.find(x.id).is_public?
    assert MediaElementsSlide.find(mes.id).media_element.is_public
    assert Bookmark.where(:bookmarkable_type => 'MediaElement', :bookmarkable_id => MediaElementsSlide.find(mes.id).media_element_id).any?
  end
  
  test 'unpublish_lesson' do
    x = Lesson.new
    assert !x.unpublish
    assert_equal 1, x.errors.messages[:base].length
    assert_match /Lesson sharing could not be undone/, x.errors.messages[:base].first
    x = Lesson.find 1
    assert !x.unpublish
    assert_equal 1, x.errors.messages[:base].length
    assert_match /This lesson has not been shared yet/, x.errors.messages[:base].first
    x = Lesson.find 2
    assert VirtualClassroomLesson.where(:lesson_id => 2).any?
    assert Bookmark.where(:bookmarkable_type => 'Lesson', :bookmarkable_id => 2).any?
    assert_equal 3, MediaElement.where(:is_public => true).count
    assert Notification.where(:user_id => 1, :message => "The user <b>eef fuu</b>, author of '<b>string</b>', changed to <i>private</i> the status of his lesson: hence, you lost the link to that lesson").empty?
    assert x.unpublish
    assert !Lesson.find(x.id).is_public
    assert VirtualClassroomLesson.where(:lesson_id => 2).empty?
    assert Bookmark.where(:bookmarkable_type => 'Lesson', :bookmarkable_id => 2).empty?
    assert Notification.where(:user_id => 1, :message => "The user <b>eef fuu</b>, author of '<b>string</b>', changed to <i>private</i> the status of his lesson: hence, you lost the link to that lesson").any?, Notification.where(:user_id => 1).inspect
    assert_equal 3, MediaElement.where(:is_public => true).count
    lesson = Lesson.find 1
    assert lesson.publish
    vc = VirtualClassroomLesson.new
    vc.user_id = lesson.user_id
    vc.lesson_id = lesson.id
    assert_obj_saved vc
    assert lesson.unpublish
    assert VirtualClassroomLesson.where(:user_id => lesson.user_id, :lesson_id => lesson.id).any?
  end
  
  test 'create_lesson' do
    assert !User.new.create_lesson('te', 'dsf', 1, 'gatto, cane, topo, orso')
    @user = User.find 1
    assert UsersSubject.where(:user_id => 1, :subject_id => 2).empty?
    assert @user.create_lesson('te', 'dsf', 2, 'gatto, cane, topo, orso').kind_of?(Hash)
    assert @user.create_lesson('te', 'dsf', 2, 'gatto, cane, topo').kind_of?(Hash)
    resp = @user.create_lesson('gs', 'gshsf', 3, 'gatto, cane, topo, orso')
    assert !resp.kind_of?(Hash)
    assert_equal 'gs', resp.title
    assert_equal 'gshsf', resp.description
    assert_equal 3, resp.subject_id
    assert_equal 1, resp.school_level_id
    assert_equal 1, resp.user_id
    assert_equal false, resp.copied_not_modified
    assert_equal false, resp.is_public
    assert_tags resp, ['gatto', 'cane', 'orso', 'topo']
  end
  
  test 'destroy_lesson_with_notifications' do
    x = Lesson.new
    assert !x.destroy_with_notifications
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The lesson could not be deleted/, x.errors.messages[:base].first
    x = Lesson.find 2
    assert Notification.where(:message => "The user <b>eef fuu</b>, author of '<b>string</b>', deleted his lesson: hence, you lost the link to that lesson").empty?
    assert x.destroy_with_notifications
    x = Notification.where(:message => "The user <b>eef fuu</b>, author of '<b>string</b>', deleted his lesson: hence, you lost the link to that lesson").first
    assert_equal 1, x.user_id
    assert !Lesson.exists?(2)
  end
  
  test 'change_slide_position' do
    uu = Slide.new
    assert !uu.change_position(1)
    s = Slide.new :position => 4, :title => 'Titolo', :text => 'Testo testo testo'
    s.lesson_id = 2
    s.kind = 'text'
    assert_obj_saved s
    assert_equal 4, Slide.where(:lesson_id => 2).count
    assert !Slide.new.change_position(1)
    x = Slide.find 3
    assert_equal 2, x.position
    assert x.change_position 2
    x = Slide.find 3
    assert_equal 2, x.position
    x = Slide.find 1
    assert_equal 'cover', x.kind
    assert !x.change_position(2)
    x = Slide.find 3
    assert !x.change_position(1)
    assert !x.change_position(20)
    assert !x.change_position('sdgsg')
    assert !x.change_position(-4)
    assert !x.change_position(0)
    s1 = Slide.where(:lesson_id => 2, :position => 1).first.id
    s2 = Slide.where(:lesson_id => 2, :position => 2).first.id
    s3 = Slide.where(:lesson_id => 2, :position => 3).first.id
    s4 = Slide.where(:lesson_id => 2, :position => 4).first.id
    assert Slide.find(s2).change_position(4)
    assert_equal 1, Slide.find(s1).position
    assert_equal 2, Slide.find(s3).position
    assert_equal 3, Slide.find(s4).position
    assert_equal 4, Slide.find(s2).position
    assert Slide.find(s2).change_position(3)
    assert_equal 1, Slide.find(s1).position
    assert_equal 2, Slide.find(s3).position
    assert_equal 3, Slide.find(s2).position
    assert_equal 4, Slide.find(s4).position
  end
  
  test 'add_slide_to_lesson' do
    assert Lesson.new.add_slide('text', 2).nil?
    x = Lesson.find 1
    assert_equal 1, x.slides.count
    assert Slide.where(:lesson_id => 1, :kind => 'image1').empty?
    assert x.add_slide('video4', 2).nil?
    ressp = x.add_slide('image1', 2)
    assert !ressp.nil?
    assert_equal 2, Slide.where(:lesson_id => 1).count
    assert Slide.where(:lesson_id => 1, :kind => 'image1').any?
    new_added_slide = Slide.where(:lesson_id => 1, :kind => 'image1').first
    assert_equal ressp.id, new_added_slide.id
    assert x.add_slide('image2', 1).nil?
    assert_equal 2, Slide.where(:lesson_id => 1).count
    ressp = x.add_slide('image2', 2)
    assert !ressp.nil?
    assert_equal 3, Slide.where(:lesson_id => 1).count
    added_second_slide =  Slide.where(:lesson_id => 1, :kind => 'image2').first
    assert_equal ressp.id, added_second_slide.id
    assert_equal 2, added_second_slide.position
    assert_equal 3, Slide.find(new_added_slide.id).position
  end
  
  test 'remove_slide_from_lesson' do
    x = Slide.new
    assert !x.destroy_with_positions
    x = Slide.where(:kind => 'cover').first
    assert !x.destroy_with_positions
    x = Slide.find 3
    assert x.kind != 'cover'
    assert_equal 3, Slide.where(:lesson_id => x.lesson_id).count
    assert_equal 2, x.position
    destroyed_id = x.id
    our_lesson_id = x.lesson_id
    third_id = Slide.where(:position => 3, :lesson_id => x.lesson_id).first.id
    assert x.destroy_with_positions
    assert !Slide.exists?(destroyed_id)
    assert_equal 2, Slide.find(third_id).position
    assert_equal 2, Slide.where(:lesson_id => our_lesson_id).count
  end
  
  test 'remove_media_element' do
    x = MediaElement.new
    assert !x.check_and_destroy
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The element could not be deleted/, x.errors.messages[:base].first
    x = MediaElement.where(:is_public => true).first
    assert !x.check_and_destroy
    assert_equal 1, x.errors.messages[:base].length
    assert_match /This element is public, you can't delete it/, x.errors.messages[:base].first
    x = MediaElement.find(3)
    assert_equal 2, x.user_id
    assert_equal false, x.is_public
    ss = Slide.find(3)
    assert_equal 2, ss.position
    assert_equal 2, ss.lesson.user_id
    assert_equal 'audio', ss.kind
    mm = MediaElementsSlide.new
    mm.media_element_id = 3
    mm.slide_id = 3
    mm.position = 1
    assert_obj_saved mm
    my_new_id = mm.id
    assert x.check_and_destroy
    assert !MediaElement.exists?(3)
    assert !MediaElementsSlide.exists?(my_new_id)
  end
  
  test 'change_position_in_virtual_classroom_playlist' do
    user = User.find 2
    lesson1 = user.create_lesson 'lesson1', 'lesson1', 1, 'gatto, cane, topo, orso'
    lesson2 = user.create_lesson 'lesson2', 'lesson2', 1, 'gatto, cane, topo, orso'
    lesson3 = user.create_lesson 'lesson3', 'lesson3', 1, 'gatto, cane, topo, orso'
    lesson4 = user.create_lesson 'lesson4', 'lesson4', 1, 'gatto, cane, topo, orso'
    lesson5 = user.create_lesson 'lesson5', 'lesson5', 1, 'gatto, cane, topo, orso'
    assert !lesson1.nil? && !lesson2.nil? && !lesson3.nil? && !lesson4.nil? && !lesson5.nil?
    cont = 2
    [lesson1, lesson2, lesson3, lesson4, lesson5].each do |l|
      l.is_public = true
      assert_obj_saved l
      b = Bookmark.new
      b.bookmarkable_type = 'Lesson'
      b.bookmarkable_id = l.id
      b.user_id = 1
      assert_obj_saved b
      vvv = VirtualClassroomLesson.new
      vvv.user_id = 1
      vvv.lesson_id = l.id
      assert_obj_saved vvv
      vvv.position = cont
      assert_obj_saved vvv
      cont += 1
    end
    assert_equal 6, VirtualClassroomLesson.where(:user_id => 1).count
    vc1 = VirtualClassroomLesson.new
    vc1.lesson_id = lesson1.id
    vc1.user_id = 2
    assert_obj_saved vc1
    vc1.position = 1
    assert_obj_saved vc1
    vc2 = VirtualClassroomLesson.new
    vc2.lesson_id = lesson2.id
    vc2.user_id = 2
    assert_obj_saved vc2
    vc2.position = 2
    assert_obj_saved vc2
    vc3 = VirtualClassroomLesson.new
    vc3.lesson_id = lesson3.id
    vc3.user_id = 2
    assert_obj_saved vc3
    vc3.position = 3
    assert_obj_saved vc3
    vc4 = VirtualClassroomLesson.new
    vc4.lesson_id = lesson4.id
    vc4.user_id = 2
    assert_obj_saved vc4
    vc4.position = 4
    assert_obj_saved vc4
    vc5 = VirtualClassroomLesson.new
    vc5.lesson_id = lesson5.id
    vc5.user_id = 2
    assert_obj_saved vc5
    assert_equal 1, vc1.position
    assert_equal 2, vc2.position
    assert_equal 3, vc3.position
    assert_equal 4, vc4.position
    assert vc5.position.nil?
    x = VirtualClassroomLesson.new
    assert !x.change_position(10)
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The lesson's position could not be changed/, x.errors.messages[:base].first
    assert !vc1.change_position(-9)
    assert_equal 1, vc1.errors.messages[:base].length
    assert_match /The position of the lesson is not valid/, vc1.errors.messages[:base].first
    assert !vc1.change_position(0)
    assert_equal 1, vc1.errors.messages[:base].length
    assert_match /The position of the lesson is not valid/, vc1.errors.messages[:base].first
    assert !vc1.change_position(5)
    assert_equal 1, vc1.errors.messages[:base].length
    assert_match /The position of the lesson is not valid/, vc1.errors.messages[:base].first
    assert !vc1.change_position('dvsdds')
    assert_equal 1, vc1.errors.messages[:base].length
    assert_match /The position of the lesson is not valid/, vc1.errors.messages[:base].first
    assert !vc5.change_position(1)
    assert_equal 1, vc5.errors.messages[:base].length
    assert_match /The lesson's position could not be changed/, vc5.errors.messages[:base].first
    assert vc2.change_position(2)
    assert_equal 1, VirtualClassroomLesson.find(vc1.id).position
    assert_equal 2, VirtualClassroomLesson.find(vc2.id).position
    assert_equal 3, VirtualClassroomLesson.find(vc3.id).position
    assert_equal 4, VirtualClassroomLesson.find(vc4.id).position
    assert VirtualClassroomLesson.find(vc5.id).position.nil?
    assert vc2.change_position(4)
    assert_equal 1, VirtualClassroomLesson.find(vc1.id).position
    assert_equal 4, VirtualClassroomLesson.find(vc2.id).position
    assert_equal 2, VirtualClassroomLesson.find(vc3.id).position
    assert_equal 3, VirtualClassroomLesson.find(vc4.id).position
    assert VirtualClassroomLesson.find(vc5.id).position.nil?
    assert vc2.change_position(1)
    assert_equal 2, VirtualClassroomLesson.find(vc1.id).position
    assert_equal 1, VirtualClassroomLesson.find(vc2.id).position
    assert_equal 3, VirtualClassroomLesson.find(vc3.id).position
    assert_equal 4, VirtualClassroomLesson.find(vc4.id).position
    assert VirtualClassroomLesson.find(vc5.id).position.nil?
  end
  
  test 'add_to_playlist' do
    x = VirtualClassroomLesson.new
    assert !x.add_to_playlist
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The lesson could not be added to the playlist/, x.errors.messages[:base].first
    x = VirtualClassroomLesson.last
    assert x.in_playlist?
    assert_equal 1, VirtualClassroomLesson.count
    assert x.add_to_playlist
    assert VirtualClassroomLesson.find(x.id).in_playlist?
    assert_equal 1, VirtualClassroomLesson.find(x.id).position
    assert_equal 1, VirtualClassroomLesson.count
    lesson1 = User.find(1).create_lesson 'lesson1', 'lesson1', 1, 'gatto, cane, topo, orso'
    xx = VirtualClassroomLesson.new
    xx.lesson_id = lesson1.id
    xx.user_id = 1
    assert_obj_saved xx
    xx = VirtualClassroomLesson.find(xx.id)
    assert xx.position.nil?
    assert_equal 2, VirtualClassroomLesson.count
    assert xx.add_to_playlist
    assert_equal 2, VirtualClassroomLesson.count
    assert_equal 1, VirtualClassroomLesson.find(xx.id).position
    assert_equal 2, VirtualClassroomLesson.find(x.id).position
    # I try the error message for full playlist
    user = User.find VirtualClassroomLesson.last.user_id
    assert_equal 1, user.id
    assert !user.playlist_full?
    Lesson.where(:user_id => 1).each do |l|
      l.destroy
    end
    VirtualClassroomLesson.where(:user_id => 1).each do |vcl|
      vcl.destroy
    end
    assert Lesson.where(:user_id => 1).empty?
    assert VirtualClassroomLesson.where(:user_id => 1).empty?
    user = User.find 1
    (0...20).each do |i|
      x = user.create_lesson "title_#{i}", "description_#{i}", 1, 'paperino, pippo, pluto, topolino'
      assert x
      assert x.add_to_virtual_classroom 1
      vc = VirtualClassroomLesson.where(:user_id => 1, :lesson_id => x.id).first
      assert vc.add_to_playlist, "Failed adding to playlist the lesson #{vc.lesson.inspect}"
      assert !user.playlist_full? if i != 19
    end
    assert_equal 20, Lesson.where(:user_id => 1).count
    assert_equal 20, VirtualClassroomLesson.where(:user_id => 1).count
    assert_equal 20, user.playlist.length
    x = user.create_lesson "title_20", "description_20", 1, 'paperino, pippo, pluto, topolino'
    assert x
    assert x.add_to_virtual_classroom 1
    vc = VirtualClassroomLesson.where(:user_id => 1, :lesson_id => x.id).first
    assert vc.position.nil?
    assert user.playlist_full?
    assert !vc.add_to_playlist
    assert_equal 1, vc.errors.messages[:base].length
    assert_match /Your playlist is full!/, vc.errors.messages[:base].first
  end
  
  test 'remove_from_playlist' do
    x = VirtualClassroomLesson.new
    assert !x.remove_from_playlist
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The lesson could not be removed from the playlist/, x.errors.messages[:base].first
    lesson1 = User.find(1).create_lesson 'lesson1', 'lesson1', 1, 'gatto, cane, topo, orso'
    xx = VirtualClassroomLesson.new
    xx.lesson_id = lesson1.id
    xx.user_id = 1
    assert_obj_saved xx
    xx = VirtualClassroomLesson.find(xx.id)
    assert xx.add_to_playlist
    assert_equal 2, VirtualClassroomLesson.where(:user_id => 1).count
    assert_equal 1, VirtualClassroomLesson.find(xx.id).position
    vvv = VirtualClassroomLesson.find(xx.id)
    assert vvv.change_position(2)
    assert_equal 2, VirtualClassroomLesson.find(xx.id).position
    assert VirtualClassroomLesson.find(1).remove_from_playlist
    assert VirtualClassroomLesson.find(1).position.nil?
    assert_equal 1, VirtualClassroomLesson.find(xx.id).position
    assert_equal 2, VirtualClassroomLesson.where(:user_id => 1).count
    assert VirtualClassroomLesson.find(1).remove_from_playlist
    assert VirtualClassroomLesson.find(1).position.nil?
    assert_equal 1, VirtualClassroomLesson.find(xx.id).position
    assert_equal 2, VirtualClassroomLesson.where(:user_id => 1).count
  end
  
  test 'add_to_virtual_classroom' do
    assert_equal 1, VirtualClassroomLesson.count
    assert VirtualClassroomLesson.exists?(1)
    x = Lesson.new
    assert !x.add_to_virtual_classroom(1)
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The lesson could not be added to your Virtual Classroom/, x.errors.messages[:base].first
    x = Lesson.find 1
    assert !x.add_to_virtual_classroom(0)
    assert !x.add_to_virtual_classroom(100)
    x = Lesson.find 2
    assert !x.add_to_virtual_classroom(1)
    assert_equal 1, x.errors.messages[:base].length
    assert_match /This lesson is already in your Virtual Classroom/, x.errors.messages[:base].first
    x = Lesson.find 1
    assert !x.add_to_virtual_classroom(2)
    assert_equal 1, x.errors.messages[:base].length
    assert_match /This lesson cannot be added to your Virtual Classroom/, x.errors.messages[:base].first
    assert x.add_to_virtual_classroom(1)
    assert_equal 2, VirtualClassroomLesson.count
    vc = VirtualClassroomLesson.where(:lesson_id => 1, :user_id => 1).first
    assert vc.id != 1
    assert_equal 1, vc.user_id
    assert_equal 1, vc.lesson_id
    assert vc.position.nil?
  end
  
  test 'remove_from_virtual_classroom' do
    assert_equal 1, VirtualClassroomLesson.count
    x = Lesson.new
    assert !x.remove_from_virtual_classroom(1)
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The lesson could not be removed from your Virtual Classroom/, x.errors.messages[:base].first
    x = Lesson.find 2
    assert !x.remove_from_virtual_classroom(100)
    assert !x.remove_from_virtual_classroom('sbsg')
    assert x.remove_from_virtual_classroom(1)
    assert_equal 0, VirtualClassroomLesson.count
    assert x.remove_from_virtual_classroom(1)
  end
  
  test 'like_and_dislike' do
    u = User.find(1)
    le = u.create_lesson('grg', 'fsbfs', 1, 'gatto, cane, topo, orso')
    assert !User.new.like(le.id)
    assert !u.like(le.id)
    assert !u.like(1000)
    u2 = User.find(2)
    assert u2.like(le.id)
    assert_equal 1, Like.where(:user_id => 2, :lesson_id => le.id).count
    assert u2.like(le.id)
    assert_equal 1, Like.where(:user_id => 2, :lesson_id => le.id).count
    assert u2.dislike(le.id)
    assert Like.where(:user_id => 2, :lesson_id => le.id).empty?
    assert u2.dislike(le.id)
    assert Like.where(:user_id => 2, :lesson_id => le.id).empty?
  end
  
  test 'reports' do
    x = User.new
    assert !x.report_lesson(1, 'ciao')
    assert_equal 1, x.errors.messages[:base].length
    assert_match /Your report could not be sent/, x.errors.messages[:base].first
    assert !x.report_media_element(1, 'ciao')
    assert_equal 1, x.errors.messages[:base].length
    assert_match /Your report could not be sent/, x.errors.messages[:base].first
    x = User.find(2)
    assert !x.report_media_element(100, 'ciao')
    assert_equal 1, x.errors.messages[:base].length
    assert_match /Your report could not be sent/, x.errors.messages[:base].first
    assert !x.report_lesson(100, 'ciao')
    assert_equal 1, x.errors.messages[:base].length
    assert_match /Your report could not be sent/, x.errors.messages[:base].first
    assert Report.where(:reportable_id => 1, :reportable_type => 'Lesson', :user_id => 2).empty?
    assert x.report_lesson 1, 'ciao'
    assert Report.where(:reportable_id => 1, :reportable_type => 'Lesson', :user_id => 2).any?
    assert !x.report_lesson(1, 'ciao')
    assert_equal 1, x.errors.messages[:base].length
    assert_match /You already reported this lesson/, x.errors.messages[:base].first
    assert Report.where(:reportable_id => 1, :reportable_type => 'MediaElement', :user_id => 2).empty?
    assert x.report_media_element 1, 'ciao'
    assert Report.where(:reportable_id => 1, :reportable_type => 'MediaElement', :user_id => 2).any?
    assert !x.report_media_element(1, 'ciao')
    assert_equal 1, x.errors.messages[:base].length
    assert_match /You already reported this element/, x.errors.messages[:base].first
  end
  
  test 'update_slide' do
    lesson = User.find(1).create_lesson('titolo', 'desc', 1, 'pippo, paperoga, pluto, qui quo qua')
    assert !lesson.nil?
    assert lesson.publish
    slide = lesson.add_slide('image1', 2)
    assert !slide.nil?
    assert !Slide.new.update_with_media_elements('titolo', 'testo', {1 => [0, 0, 'asdgs']})
    assert slide.title.blank?
    assert slide.text.blank?
    assert !MediaElement.find(5).is_public
    assert slide.update_with_media_elements('titolo2', 'testo2', {1 => [5, 0, 'captionzz']})
    assert MediaElement.find(5).is_public
    slide.reload
    assert_equal 'titolo2', slide.title
    assert_equal 'testo2', slide.text
    mes = MediaElementsSlide.where(:slide_id => slide.id, :media_element_id => 5).first
    assert !mes.nil?
    assert_equal 0, mes.alignment
    assert_equal 'captionzz', mes.caption
    # video in an image slide
    assert !slide.update_with_media_elements('titolo4', 'testo4', {1 => [1, 0, 'captionzz']})
    slide = Slide.find slide.id
    assert_equal 'titolo2', slide.title
    # too many elements
    assert !slide.update_with_media_elements('titolo4', 'testo4', {1 => [5, 0, 'captionzz'], 2 => [5, 0, 'captionzz']})
    slide = Slide.find slide.id
    assert_equal 'titolo2', slide.title
    # let's try with image4
    slide = lesson.add_slide('image4', 2)
    assert !slide.nil?
    assert slide.title.blank?
    assert slide.text.blank?
    assert MediaElementsSlide.where(:slide_id => slide.id).empty?
    assert slide.update_with_media_elements(nil, nil, {1 => [5, 0, 'caption1'], 2 => [6, 10, 'caption2'], 3 => [5, -110, 'caption3'], 4 => [6, 4, 'caption4']})
    slide = Slide.find slide.id
    assert slide.title.blank?
    assert slide.text.blank?
    mes = MediaElementsSlide.where(:slide_id => slide.id, :position => 1).first
    assert !mes.nil?
    assert_equal 0, mes.alignment
    assert_equal 'caption1', mes.caption
    stored_id_me = mes.id
    mes = MediaElementsSlide.where(:slide_id => slide.id, :position => 2).first
    assert !mes.nil?
    assert_equal 10, mes.alignment
    assert_equal 'caption2', mes.caption
    mes = MediaElementsSlide.where(:slide_id => slide.id, :position => 3).first
    assert !mes.nil?
    assert_equal -110, mes.alignment
    assert_equal 'caption3', mes.caption
    mes = MediaElementsSlide.where(:slide_id => slide.id, :position => 4).first
    assert !mes.nil?
    assert_equal 4, mes.alignment
    assert_equal 'caption4', mes.caption
    assert_equal 4, MediaElementsSlide.where(:slide_id => slide.id).count
    count_media_elements_slide = MediaElementsSlide.count
    assert slide.update_with_media_elements(nil, nil, {1 => [6, 0, 'caption1'], 2 => [6, 10, 'caption2'], 3 => [5, -110, 'caption3'], 4 => [6, 4, 'caption4']})
    assert_equal count_media_elements_slide, MediaElementsSlide.count
    assert_equal 6, MediaElementsSlide.find(stored_id_me).media_element_id
  end
  
  test 'modify_lesson' do
    # FIRST COPY
    first_copy = Lesson.find(2).copy(1)
    assert !first_copy.nil?
    assert first_copy.copied_not_modified
    assert first_copy.copy(2).nil?
    assert_equal 3, Slide.where(:lesson_id => first_copy.id).count
    s = Slide.where(:position => 2, :lesson_id => first_copy.id).first
    assert s.change_position 3
    first_copy = Lesson.find(first_copy.id)
    assert !first_copy.copied_not_modified
    # SECOND COPY
    second_copy = first_copy.copy(1)
    assert !second_copy.nil?
    assert second_copy.copied_not_modified
    assert second_copy.add_slide 'title', 2
    second_copy = Lesson.find(second_copy.id)
    assert !second_copy.copied_not_modified
    # THIRD COPY
    third_copy = second_copy.copy(1)
    assert !third_copy.nil?
    assert third_copy.copied_not_modified
    assert_equal 4, Slide.where(:lesson_id => third_copy.id).count
    s = Slide.where(:position => 4, :lesson_id => third_copy.id).first
    assert s.update_with_media_elements('blaah', nil, {})
    third_copy = Lesson.find third_copy.id
    assert !third_copy.copied_not_modified
    # FOURTH COPY
    fourth_copy = third_copy.copy(1)
    assert !fourth_copy.nil?
    assert fourth_copy.copied_not_modified
    assert_equal 4, Slide.where(:lesson_id => fourth_copy.id).count
    s = Slide.where(:position => 4, :lesson_id => fourth_copy.id).first
    assert s.destroy_with_positions
    fourth_copy = Lesson.find fourth_copy.id
    assert !fourth_copy.copied_not_modified
  end
  
end
