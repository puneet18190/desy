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
  
  test 'impossible_changes' do
    assert_obj_saved @bookmark
    @bookmark.user_id = 2
    assert !@bookmark.save, "Bookmark erroneously saved - #{@bookmark.inspect}"
    assert_equal 2, @bookmark.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@bookmark.errors.inspect}"
    assert_match /can't be changed/, @bookmark.errors.messages[:user_id].first
    @bookmark.user_id = 1
    assert @bookmark.valid?, "Bookmark not valid: #{@bookmark.errors.inspect}"
    @bookmark.bookmarkable_id = 2
    assert !@bookmark.save, "Bookmark erroneously saved - #{@bookmark.inspect}"
    assert_equal 1, @bookmark.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@bookmark.errors.inspect}"
    my_errors = ''
    @bookmark.errors.messages[:bookmarkable_id].each do |eee|
      my_errors = "#{my_errors}#{eee}"
    end
    assert_match /can't be changed/, my_errors
    @bookmark.bookmarkable_id = @lesson.id
    assert @bookmark.valid?, "Bookmark not valid: #{@bookmark.errors.inspect}"
    @bookmark.bookmarkable_type = 'MediaElement'
    assert !@bookmark.save, "Bookmark erroneously saved - #{@bookmark.inspect}"
    assert_equal 2, @bookmark.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@bookmark.errors.inspect}"
    assert_match /can't be changed/, @bookmark.errors.messages[:bookmarkable_type].first
    @bookmark.bookmarkable_type = 'Lesson'
    assert @bookmark.valid?, "Bookmark not valid: #{@bookmark.errors.inspect}"
    assert_obj_saved @bookmark
  end
  
  test 'availability' do
    assert_invalid @bookmark, :bookmarkable_id, 1, @lesson_id, /lesson not available for bookmarks/
    @lesson.is_public = false
    assert_obj_saved @lesson
    assert !@bookmark.save, "Bookmark erroneously saved - #{@bookmark.inspect}"
    assert_equal 1, @bookmark.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@bookmark.errors.inspect}"
    assert_equal 1, @bookmark.errors.size
    assert_match /lesson not available for bookmarks/, @bookmark.errors.messages[:bookmarkable_id].first
    @lesson.is_public = true
    assert_obj_saved @lesson
    assert @bookmark.valid?, "Bookmark not valid: #{@bookmark.errors.inspect}"
    @bookmark.bookmarkable_type = 'MediaElement'
    assert_invalid @bookmark, :bookmarkable_id, 1, 2, /media element not available for bookmarks/
    assert_invalid @bookmark, :bookmarkable_id, 3, 6, /media element not available for bookmarks/
    assert_obj_saved @bookmark
  end
  
end
