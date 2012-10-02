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
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Bookmark.new(:tag_id => 1)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Bookmark.new(:taggable_id => 2)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Bookmark.new(:taggable_type => 'MediaElement')}
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
  
end
