require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase
  
  def setup
    @lesson = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
    @lesson.copied_not_modified = false
    @lesson.user_id = 2
    @lesson.save
    @bookmark = Bookmark.new
    @bookmark.user_id = 1
    @bookmark.bookmarkable_type = 'Lesson'
    @bookmark.bookmarkable_id = @lesson.id
  end
  
 # test 'empty_and_defaults' do
 #   @bookmark = Bookmark.new
 #   assert_error_size 1, @bookmark
 # end
  
  test 'attr_accessible' do
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Bookmark.new(:user_id => 1)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Bookmark.new(:bookmarkable_id => 2)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Bookmark.new(:bookmarkable_type => 'MediaElement')}
  end
  
 # test 'types' do
 #   assert_invalid @bookmark, :description, long_string(256), long_string(255), /is too long/
 #   assert_obj_saved @bookmark
 # end
  
  test 'association_methods' do
    assert_nothing_raised {@bookmark.user}
    assert_nothing_raised {@bookmark.bookmarkable}
  end
  
end
