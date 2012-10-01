require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase
  
  def setup
    @lesson = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
    @lesson.copied_not_modified = false
    @lesson.user_id = 2
    @lesson.save
    @lesson.is_public = true
    @lesson.save
    @bookmark = Bookmark.new
    @bookmark.user_id = 1
    @bookmark.bookmarkable_type = 'Lesson'
    @bookmark.bookmarkable_id = @lesson.id
  end
  
  test 'empty_and_defaults' do
    @bookmark = Bookmark.new
    assert_error_size 6, @bookmark
  end
  
  test 'attr_accessible' do
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Bookmark.new(:user_id => 1)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Bookmark.new(:bookmarkable_id => 2)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Bookmark.new(:bookmarkable_type => 'MediaElement')}
  end
  
  test 'types' do
    assert_invalid @bookmark, :user_id, 'rt', 1, /is not a number/
    assert_invalid @bookmark, :user_id, 9.9, 1, /must be an integer/
    assert_invalid @bookmark, :bookmarkable_id, -8, @lesson.id, /must be greater than 0/
    assert_invalid @bookmark, :bookmarkable_type, 'Lessen', 'Lesson', /is not included in the list/
    assert_obj_saved @bookmark
  end
  
  test 'association_methods' do
    assert_nothing_raised {@bookmark.user}
    assert_nothing_raised {@bookmark.bookmarkable}
  end
  
  test 'uniqueness' do
    assert_invalid @bookmark, :bookmarkable_id, 2, @lesson.id, /has already been taken/
    assert_obj_saved @bookmark
  end
  
  test 'associations' do
    assert_invalid @bookmark, :user_id, 1000, 1, /doesn't exist/
    assert_invalid @bookmark, :bookmarkable_id, 1000, @lesson.id, /lesson doesn't exist/
    assert_obj_saved @bookmark
    @bookmark = Bookmark.find 2
    assert_invalid @bookmark, :bookmarkable_id, 1000, 4, /media element doesn't exist/
    assert_obj_saved @bookmark
  end
  
end
