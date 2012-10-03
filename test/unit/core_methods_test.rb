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
  
end
