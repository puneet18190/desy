require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    begin
      @user = User.confirmed.new(:name => 'Javier Ernesto', :surname => 'Chevanton', :school_level_id => 1, :school => 'Scuola', :location_id => 1, :password => 'osososos', :password_confirmation => 'osososos', :subject_ids => [1]) do |user|
        user.email = 'em1@em.em'
      end
      @user.policy_1 = '1'
      @user.policy_2 = '1'
    rescue ActiveModel::MassAssignmentSecurity::Error => err
      @user = nil
    end
  end
  
  test 'empty_and_defaults' do
    @user = User.new
    assert_error_size 15, @user
  end
  
  test 'attr_accessible' do
    assert !@user.nil?
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {User.new(:email => 'err@sdd.oo')}
  end
  
  test 'types' do
    @user.name = long_string(256)
    assert !@user.save, "User erroneously saved - #{@user.inspect}"
    assert_equal [:email, :name], @user.errors.messages.keys.sort, "A field which wasn't supposed to be affected returned error - #{@user.errors.inspect}"
    assert_equal 1, @user.errors.messages[:name].length
    assert @user.errors.messages[:email].empty?
    assert_match /is too long/, array_to_string(@user.errors.messages[:name])
    @user.name = long_string(255)
    assert @user.valid?, "User not valid: #{@user.errors.inspect}"
    @user.surname = long_string(256)
    assert !@user.save, "User erroneously saved - #{@user.inspect}"
    assert_equal [:email, :surname], @user.errors.messages.keys.sort, "A field which wasn't supposed to be affected returned error - #{@user.errors.inspect}"
    assert_equal 1, @user.errors.messages[:surname].length
    assert @user.errors.messages[:email].empty?
    assert_match /is too long/, array_to_string(@user.errors.messages[:surname])
    @user.surname = long_string(255)
    assert @user.valid?, "User not valid: #{@user.errors.inspect}"
    @user.school = long_string(256)
    assert !@user.save, "User erroneously saved - #{@user.inspect}"
    assert_equal [:email, :school], @user.errors.messages.keys.sort, "A field which wasn't supposed to be affected returned error - #{@user.errors.inspect}"
    assert_equal 1, @user.errors.messages[:school].length
    assert @user.errors.messages[:email].empty?
    assert_match /is too long/, array_to_string(@user.errors.messages[:school])
    @user.school = long_string(255)
    assert @user.valid?, "User not valid: #{@user.errors.inspect}"
    @user.school_level_id = 'er'
    assert !@user.save, "User erroneously saved - #{@user.inspect}"
    assert_equal [:email, :school_level_id], @user.errors.messages.keys.sort, "A field which wasn't supposed to be affected returned error - #{@user.errors.inspect}"
    assert_equal 2, @user.errors.messages[:school_level_id].length
    assert @user.errors.messages[:email].empty?
    assert_match /is not a number/, array_to_string(@user.errors.messages[:school_level_id])
    @user.school_level_id = 1
    assert @user.valid?, "User not valid: #{@user.errors.inspect}"
    @user.location_id = -2
    assert !@user.save, "User erroneously saved - #{@user.inspect}"
    assert_equal [:email, :location_id], @user.errors.messages.keys.sort, "A field which wasn't supposed to be affected returned error - #{@user.errors.inspect}"
    assert_equal 2, @user.errors.messages[:location_id].length
    assert @user.errors.messages[:email].empty?
    assert_match /must be greater than 0/, array_to_string(@user.errors.messages[:location_id])
    @user.location_id = 1
    assert @user.valid?, "User not valid: #{@user.errors.inspect}"
    @user.location_id = 2.8
    assert !@user.save, "User erroneously saved - #{@user.inspect}"
    assert_equal [:email, :location_id], @user.errors.messages.keys.sort, "A field which wasn't supposed to be affected returned error - #{@user.errors.inspect}"
    assert_equal 2, @user.errors.messages[:location_id].length
    assert @user.errors.messages[:email].empty?
    assert_match /must be an integer/, array_to_string(@user.errors.messages[:location_id])
    @user.location_id = 1
    assert @user.valid?, "User not valid: #{@user.errors.inspect}"
    assert_obj_saved @user
  end
  
  test 'uniqueness' do
    assert_invalid @user, :email, 'pluto@pippo.it', 'reer@dsigs.nz', /has already been taken/
    assert_obj_saved @user
  end
  
  test 'associations' do
    @user.location_id = 1900
    assert !@user.save, "User erroneously saved - #{@user.inspect}"
    assert_equal [:email, :location_id], @user.errors.messages.keys.sort, "A field which wasn't supposed to be affected returned error - #{@user.errors.inspect}"
    assert_equal 1, @user.errors.messages[:location_id].length
    assert @user.errors.messages[:email].empty?
    assert_match /can't be blank/, array_to_string(@user.errors.messages[:location_id]), @user.errors.messages.inspect
    @user.location_id = 1
    assert @user.valid?, "User not valid: #{@user.errors.inspect}"
    @user.school_level_id = 1900
    assert !@user.save, "User erroneously saved - #{@user.inspect}"
    assert_equal [:email, :school_level_id], @user.errors.messages.keys.sort, "A field which wasn't supposed to be affected returned error - #{@user.errors.inspect}"
    assert_equal 1, @user.errors.messages[:school_level_id].length
    assert @user.errors.messages[:email].empty?
    assert_match /can't be blank/, array_to_string(@user.errors.messages[:school_level_id])
    @user.school_level_id = 2
    assert @user.valid?, "User not valid: #{@user.errors.inspect}"
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
