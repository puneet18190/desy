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
  
  test 'destroy_users_with_dependencies' do
    resp = User.create_user(VARIABLES['admin_email'], 'oo', 'fsg', 'asf', 1, 1, [1, 2])
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
  
end
