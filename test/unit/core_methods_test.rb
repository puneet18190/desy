require 'test_helper'

class CoreMethodsTest < ActiveSupport::TestCase
  
  test 'create_user' do
    assert_equal 2, User.count
    assert_equal 3, UsersSubject.count
    assert User.create_user('s@pippso.it', 'oo', 'fsg', 'asf', 1, 1, []).nil?
    assert User.create_user('s@pippso.it', 'oo', 'fsg', 'asf', 1, 1, 'dgsdg').nil?
    assert User.create_user('s@pippso.it', 'oo', 'fsg', 'asf', 1, 100, [1, 2]).nil?
    assert User.create_user('S@pippso.it', 'oo', 'fsg', 'asf', 1, 1, [1, 100]).nil?
    assert User.create_user('s@pippso.it', 'oo', 'fsg', 'asf', 100, 1, [1]).nil?
    assert User.create_user('pluto@pippo.it', 'oo', 'fsg', 'asf', 1, 1, [1, 2, 3]).nil?
    assert_equal 2, User.count
    assert_equal 3, UsersSubject.count
    resp = User.create_user('eee@pippo.it', 'oo', 'fsg', 'asf', 1, 1, [1, 2, 4])
    assert !resp.new_record?
    assert_equal 3, User.count
    assert_equal 6, UsersSubject.count
    resp_sub = UsersSubject.where(:user_id => resp.id).order(:subject_id)
    assert_equal 3, resp_sub.length
    assert_equal 1, resp_sub.first.subject_id
    assert_equal 2, resp_sub[1].subject_id
    assert_equal 4, resp_sub.last.subject_id
  end
  
  test 'edit_user_fields' do
    assert_equal 3, UsersSubject.count
    x = User.find 1
    assert x.name != 'oo' && x.surname != 'fsg' && x.school != 'asf'
    assert !x.edit_fields('oo', 'fsg', 'asf', 1, 1, [])
    assert !x.edit_fields('oo', 'fsg', 'asf', 1, 1, 'sgdds')
    assert !User.new.edit_fields('oo', 'fsg', 'asf', 1, 1, [1, 2])
    assert UsersSubject.where(:user_id => 1, :subject_id => 3).any?
    assert UsersSubject.where(:user_id => 1, :subject_id => 2).empty?
    assert x.edit_fields('oo', 'fsg', 'asf', 1, 1, [1, 2])
    x = User.find x.id
    assert x.name == 'oo' && x.surname == 'fsg' && x.school == 'asf'
    assert UsersSubject.where(:user_id => 1, :subject_id => 2).any?
    assert UsersSubject.where(:user_id => 1, :subject_id => 3).empty?
  end
  
  test 'destroy_users_with_dependencies' do
    resp = User.create_user(CONFIG['admin_email'], 'oo', 'fsg', 'asf', 1, 1, [1, 2])
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
    assert x.copy(2).nil?
    resp = x.copy(1)
    assert !resp.nil?
    assert x.copy(1).nil?
    assert_equal 1, x.errors.messages[:base].length
    assert_match /You already have a copy of this lesson/, x.errors.messages[:base].first
    x = Lesson.find(2)
    resp = x.copy(1)
    assert !resp.nil?
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
    assert_equal 'audio1', s2.kind
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
  end
  
  test 'publish_lesson' do
    assert !Lesson.new.publish
    x = Lesson.find 2
    assert !x.publish
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The lesson you selected has already been published/, x.errors.messages[:base].first
    x = Lesson.find 1
    new_slide = Slide.new :position => 2, :title => 'Titolo', :text => 'Testo testo testo'
    new_slide.lesson_id = 1
    new_slide.kind = 'image2'
    assert_obj_saved new_slide
    mes = MediaElementsSlide.new
    mes.slide_id = new_slide.id
    mes.media_element_id = 5
    mes.position = 2
    assert_obj_saved mes
    assert !MediaElementsSlide.find(mes.id).media_element.is_public
    assert x.publish
    assert Lesson.find(x.id).is_public?
    assert MediaElementsSlide.find(mes.id).media_element.is_public
  end
  
  test 'unpublish_lesson' do
    assert !Lesson.new.unpublish
    x = Lesson.find 1
    assert !x.unpublish
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The lesson you selected has already been unpublished/, x.errors.messages[:base].first
    x = Lesson.find 2
    assert VirtualClassroomLesson.where(:lesson_id => 2).any?
    assert Bookmark.where(:bookmarkable_type => 'Lesson', :bookmarkable_id => 2).any?
    assert_equal 3, MediaElement.where(:is_public => true).count
    assert Notification.where(:user_id => 2, :message => 'Your bookmark has been cancelled').empty?
    assert x.unpublish
    assert !Lesson.find(x.id).is_public
    assert VirtualClassroomLesson.where(:lesson_id => 2).empty?
    assert Bookmark.where(:bookmarkable_type => 'Lesson', :bookmarkable_id => 2).empty?
    assert Notification.where(:user_id => 1, :message => 'Your bookmark has been cancelled').any?
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
  
  test 'create_tags' do
    assert !Tag.create_tag_set('MidaElement', 1, [1, 2, 3])
    assert !Tag.create_tag_set('MediaElement', 7, [1, 2, 3])
    assert !Tag.create_tag_set('MediaElement', 1, [1, nil, 3])
    assert !Tag.create_tag_set('MediaElement', 1, [])
    assert !Tag.create_tag_set('MediaElement', 1, 'dsgd')
    assert !Tag.create_tag_set('MediaElement', 1, [1, 2, 'petrolio', 3, 100])
    assert !Tag.create_tag_set('MediaElement', 1, [1, 2, 'gatto', 3])
    taggings = Tagging.where :taggable_type => 'MediaElement', :taggable_id => 1
    assert_equal 2, taggings.length
    my_id = taggings.first.id
    assert Tagging.exists?(my_id)
    assert_equal 4, Tag.count
    assert Tag.create_tag_set('MediaElement', 1, [4, 'orso', 1])
    taggings = Tagging.where :taggable_type => 'MediaElement', :taggable_id => 1
    assert_equal 3, taggings.length
    assert !Tagging.exists?(my_id)
    assert_equal 5, Tag.count
  end
  
  test 'create_lesson' do
    assert !User.new.create_lesson('te', 'dsf', 1)
    @user = User.find 1
    assert UsersSubject.where(:user_id => 1, :subject_id => 2).empty?
    assert !@user.create_lesson('te', 'dsf', 2)
    resp = @user.create_lesson('gs', 'gshsf', 3)
    assert !resp.nil?
    assert_equal 'gs', resp.title
    assert_equal 'gshsf', resp.description
    assert_equal 3, resp.subject_id
    assert_equal 1, resp.school_level_id
    assert_equal 1, resp.user_id
    assert_equal false, resp.copied_not_modified
    assert_equal false, resp.is_public
  end
  
  test 'destroy_lesson_with_notifications' do
    x = Lesson.new
    assert !x.destroy_with_notifications
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The lesson could not be destroyed correctly/, x.errors.messages[:base].first
    x = Lesson.find 2
    assert Notification.where(:message => 'Your bookmark has been cancelled').empty?
    assert x.destroy_with_notifications
    x = Notification.where(:message => 'Your bookmark has been cancelled').first
    assert_equal 1, x.user_id
    assert !Lesson.exists?(2)
  end
  
  test 'change_slide_position' do
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
    assert_equal 1, x.errors.messages[:base].length
    assert_match /You cannot change the position of the cover/, x.errors.messages[:base].first
    x = Slide.find 3
    assert !x.change_position(1)
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The position of the slide is invalid/, x.errors.messages[:base].first
    assert !x.change_position(20)
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The position of the slide is invalid/, x.errors.messages[:base].first
    assert !x.change_position('sdgsg')
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The position of the slide is invalid/, x.errors.messages[:base].first
    assert !x.change_position(-4)
    assert_equal 1, x.errors.messages[:base].length
    assert_match /The position of the slide is invalid/, x.errors.messages[:base].first
  end
  
end
