require 'test_helper'

class UsersSubjectTest < ActiveSupport::TestCase
  
  def setup
    begin
      @users_subject = UsersSubject.new :user_id => 2, :subject_id => 4
    rescue ActiveModel::MassAssignmentSecurity::Error
      @users_subject = nil
    end
  end
  
  test 'empty_and_defaults' do
    @users_subject = UsersSubject.new
    assert_error_size 6, @users_subject
  end
  
  test 'attr_accessible' do
    assert !@users_subject.nil?
  end
  
  test 'types' do
    assert_invalid @users_subject, :user_id, 'tr', 2, /is not a number/
    assert_invalid @users_subject, :subject_id, 4.5, 4, /must be an integer/
    assert_invalid @users_subject, :subject_id, 0, 4, /must be greater than 0/
    assert_obj_saved @users_subject
  end
  
  test 'associations' do
    assert_invalid @users_subject, :user_id, 1000, 2, /doesn't exist/
    assert_invalid @users_subject, :subject_id, 1000, 4, /doesn't exist/
    assert_obj_saved @users_subject
  end
  
  test 'uniqueness' do
    assert_invalid @users_subject, :subject_id, 1, 4, /has already been taken/
    assert_obj_saved @users_subject
  end
  
  test 'association_methods' do
    assert_nothing_raised {@users_subject.user}
    assert_nothing_raised {@users_subject.subject}
  end
  
  test 'before_destroy' do
    @users_subject = UsersSubject.find(3)
    @users_subject.destroy
    assert UsersSubject.exists?(3)
  end
  
end
