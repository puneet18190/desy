require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  
  def setup
    @like = Like.new
    @like.user_id = 2
    @like.lesson_id = 1
  end
  
  test 'empty_and_defaults' do
    @like = Like.new
    assert_error_size 6, @like
  end
  
  test 'attr_accessible' do
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Like.new(:user_id => 1)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Like.new(:lesson_id => 1)}
  end
  
  test 'types' do
    assert_invalid @like, :user_id, '3r4', 2, /is not a number/
    assert_invalid @like, :user_id, -4, 2, /must be greater than 0/
    assert_invalid @like, :lesson_id, 2.111, 1, /must be an integer/
    assert_obj_saved @like
  end
  
  test 'association_methods' do
    assert_nothing_raised {@like.user}
    assert_nothing_raised {@like.lesson}
  end
  
  test 'uniqueness' do
    @like.user_id = 1
    @like.lesson_id = 2
    assert !@like.save, "Like erroneously saved - #{@like.inspect}"
    assert_equal 1, @like.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@like.errors.inspect}"
    assert_equal 1, @like.errors.size
    assert_match /has already been taken/, @like.errors.messages[:lesson_id].first
    @like.user_id = 2
    @like.lesson_id = 1
    assert_obj_saved @like
  end
  
  test 'associations' do
    assert_invalid @like, :user_id, 1000, 2, /doesn't exist/
    assert_invalid @like, :lesson_id, 1000, 1, /doesn't exist/
    assert_obj_saved @like
  end
  
  test 'validity' do
    assert_invalid @like, :lesson_id, 2, 1, /can't be liked/
    assert_obj_saved @like
  end
  
  test 'impossible_changes' do
    assert_obj_saved @like
    @lesson = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
    @lesson.copied_not_modified = false
    @lesson.user_id = 1
    @lesson.save
    @user = User.confirmed.new(:password => 'em1@em.em', :password_confirmation => 'em1@em.em', :name => 'dgdsg', :surname => 'sdgds', :school_level_id => 1, :location_id => 1, :subject_ids => [1]) do |user|
      user.email = 'em1@em.em'
      user.active = true
    end
    @user.policy_1 = '1'
    @user.policy_2 = '1'
    assert_obj_saved @user
    assert_invalid @like, :user_id, @user.id, 2, /can't be changed/
    assert_invalid @like, :lesson_id, @lesson.id, 1, /can't be changed/
    assert_obj_saved @like
  end
  
end
