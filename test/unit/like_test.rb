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
  
  
  
end
