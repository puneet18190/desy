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
    assert_equal 1, Lesson.where(:user_id => 1).count
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
  end
  
  test 'copy_lesson' do
    assert Lesson.new.copy(1).nil?
    x = Lesson.find(1)
    assert x.copy(100).nil?
    assert x.copy(2).nil?
    resp = x.copy(1)
    assert !resp.nil?
    assert x.copy(1).nil?
    assert_equal 'You already have a copy of this lesson', x.copy_errors
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
    assert s2.text1.blank?
    med1 = MediaElementsSlide.where(:slide_id => s2.id).first
    assert !med1.nil?
    assert_equal 4, med1.media_element_id
    s3 = Slide.where(:lesson_id => resp.id, :position => 3).first
    assert !s3.nil?
    assert_equal 'video1', s3.kind
    assert_equal 'Ciao', s3.title
    assert_equal 'beh... beh beh', s3.text1
    med2 = MediaElementsSlide.where(:slide_id => s3.id).first
    assert !med2.nil?
    assert_equal 2, med2.media_element_id
  end
  
end
