require 'test_helper'

class TaggingTest < ActiveSupport::TestCase
  
  def setup
    @tagging = Tagging.new
    @tagging.tag_id = 1
    @tagging.taggable_id = 2
    @tagging.taggable_type = 'MediaElement'
  end
  
  test 'empty_and_defaults' do
    @tagging = Tagging.new
    assert_error_size 6, @tagging
  end
  
  test 'attr_accessible' do
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Tagging.new(:tag_id => 1)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Tagging.new(:taggable_id => 2)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Tagging.new(:taggable_type => 'MediaElement')}
  end
  
  test 'types' do
    assert_invalid @tagging, :tag_id, 'rt', 1, /is not a number/
    assert_invalid @tagging, :tag_id, 9.9, 1, /must be an integer/
    assert_invalid @tagging, :taggable_id, -8, 2, /must be greater than 0/
    assert_invalid @tagging, :taggable_type, 'MidiaElement', 'MediaElement', /is not included in the list/
    assert_obj_saved @tagging
  end
  
  test 'association_methods' do
    assert_nothing_raised {@tagging.tag}
    assert_nothing_raised {@tagging.taggable}
  end
  
  test 'uniqueness' do
    @tagging.tag_id = 3
    assert_invalid @tagging, :taggable_id, 1, 2, /has already been taken/
    @tagging.taggable_type = 'Lesson'
    @tagging.tag_id = 2
    assert_invalid @tagging, :taggable_id, 1, 2, /has already been taken/
    assert_obj_saved @tagging
  end
  
  test 'associations' do
    assert_invalid @tagging, :tag_id, 1000, 1, /doesn't exist/
    assert_invalid @tagging, :taggable_id, 1000, 2, /media element doesn't exist/
    @tagging.taggable_type = 'Lesson'
    assert_invalid @tagging, :taggable_id, 1000, 1, /lesson doesn't exist/
    assert_obj_saved @tagging
  end
  
end
