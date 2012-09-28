require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    begin
      @user = User.new :name => 'Javier Ernesto', :surname => 'Chevanton', :school_level_id => 1,
        :school => 'Scuola', :location_id => 1
      @user.email = 'plutdsgso@pippo.it'
    rescue ActiveModel::MassAssignmentSecurity::Error
      @user = nil
    end
  end
  
  test 'empty_and_defaults' do
    @user = User.new
    assert_error_size 10, @user
  end
  
  test 'attr_accessible' do
    assert !@user.nil?
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {User.new(:email => 'err@sdd.oo')}
  end
  
  test 'types' do
    assert_invalid @user, :name, long_string(256), long_string(255), /is too long/
    assert_invalid @user, :surname, long_string(256), long_string(255), /is too long/
    assert_invalid @user, :email, long_string(256), 'e@e.oo', /is too long/
    assert_invalid @user, :school, long_string(256), long_string(255), /is too long/
    assert_invalid @user, :school_level_id, 'er', 1, /is not a number/
    assert_invalid @user, :location_id, -2, 1, /must be greater than 0/
    assert_invalid @user, :location_id, 2.8, 1, /must be an integer/
    assert_invalid @user, :email, 'bebebe', 'a@ciao.it', /is not in the correct format/
    assert_invalid @user, :email, 'be@bebe', 'a@ciao.it', /is not in the correct format/
    assert_invalid @user, :email, 'beb@e.b.e', 'a@ciao.it.it.it', /is not in the correct format/
    assert_obj_saved @user
  end
  
  test 'uniqueness' do
    assert_invalid @user, :email, 'pluto@pippo.it', 'reer@dsigs.nz', /has already been taken/
    assert_obj_saved @user
  end
  
  test 'change_email' do
    assert_obj_saved @user
    assert !@user.new_record?
    assert_invalid @user, :email, 'nuova@emai.il', 'plutdsgso@pippo.it', /can't change after having been initialized/
    assert_obj_saved @user
  end
  
  test 'associations' do
    assert_invalid @user, :location_id, 1900, 1, /doesn't exist/
    assert_invalid @user, :school_level_id, 1900, 2, /doesn't exist/
    assert_obj_saved @user
  end
  
  test 'association_methods' do
    assert_nothing_raised {@user.bookmarks}
    assert_nothing_raised {@user.notifications}
    assert_nothing_raised {@user.likes}
    assert_nothing_raised {@user.lessons}
    assert_nothing_raised {@user.media_elements}
    assert_nothing_raised {@user.reports}
    assert_nothing_raised {@user.users_subjects}
    assert_nothing_raised {@user.virtual_classroom_lessons}
    assert_nothing_raised {@user.school_level}
    assert_nothing_raised {@user.location}
  end
  
end
