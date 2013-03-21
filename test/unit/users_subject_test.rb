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
    assert_error_size 4, @users_subject
  end
  
  test 'attr_accessible' do
    assert !@users_subject.nil?
  end
  
  test 'uniqueness' do
    assert_invalid @users_subject, :subject_id, 1, 4, :taken
    assert_obj_saved @users_subject
  end
  
  test 'association_methods' do
    assert_nothing_raised {@users_subject.user}
    assert_nothing_raised {@users_subject.subject}
  end
  
end
