require 'test_helper'

class LessonTest < ActiveSupport::TestCase
  
  def setup
    begin
      @lesson = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
      @lesson.copied_not_modified = false
      @lesson.user_id = 1
    rescue ActiveModel::MassAssignmentSecurity::Error
      @lesson = nil
    end
  end
  
  test 'empty_and_defaults' do
    @lesson = Lesson.new
    assert !@lesson.is_public
    @lesson.is_public = nil
    @lesson.token = 'prova'
    assert_error_size 13, @lesson
    assert @lesson.token != 'prova'
    assert_equal 20, @lesson.token.length
  end
  
  test 'attr_accessible' do
    assert !@lesson.nil?
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Lesson.new(:is_public => true)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Lesson.new(:copied_not_modified => true)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Lesson.new(:parent_id => 2)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Lesson.new(:user_id => 1)}
  end
  
  test 'types' do
    assert_invalid @lesson, :user_id, 'er', 1, /is not a number/
    assert_invalid @lesson, :school_level_id, 0, 2, /must be greater than 0/
    assert_invalid @lesson, :subject_id, 0.6, 1, /must be an integer/
    assert_invalid @lesson, :parent_id, 'oip', nil, /is not a number/
    assert_invalid @lesson, :parent_id, -6, nil, /must be greater than 0/
    assert_invalid @lesson, :parent_id, 5.5, nil, /must be an integer/
    assert_invalid @lesson, :is_public, nil, false, /is not included in the list/
    assert_invalid @lesson, :copied_not_modified, nil, false, /is not included in the list/
    assert_invalid @lesson, :title, long_string(256), long_string(255), /is too long/
    assert_obj_saved @lesson
  end
  
  test 'parent_id' do
    assert_invalid @lesson, :parent_id, 1000, 1, /doesn't exist/
    assert_obj_saved @lesson
    assert_invalid @lesson, :parent_id, @lesson.id, 1, /can't be the lesson itself/
    @lesson2 = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
    @lesson2.copied_not_modified = false
    @lesson2.user_id = 1
    assert_invalid @lesson2, :parent_id, 1, @lesson.id, /has already been taken/
    assert_obj_saved @lesson2
  end
  
  test 'automatic_cover' do
    assert_obj_saved @lesson
    assert_equal 1, Slide.where(:lesson_id => @lesson.id, :kind => 'cover').length
  end
  
  test 'association_methods' do
    assert_nothing_raised {@lesson.user}
    assert_nothing_raised {@lesson.subject}
    assert_nothing_raised {@lesson.school_level}
    assert_nothing_raised {@lesson.bookmarks}
    assert_nothing_raised {@lesson.likes}
    assert_nothing_raised {@lesson.reports}
    assert_nothing_raised {@lesson.taggings}
    assert_nothing_raised {@lesson.slides}
    assert_nothing_raised {@lesson.virtual_classroom_lessons}
  end
  
  test 'associations' do
    assert_invalid @lesson, :user_id, 1000, 1, /doesn't exist/
    assert_invalid @lesson, :school_level_id, 1000, 2, /doesn't exist/
    assert_invalid @lesson, :subject_id, 1000, 1, /doesn't exist/
    assert_obj_saved @lesson
  end
  
  test 'booleans' do
    assert_invalid @lesson, :is_public, true, false, /can't be true for new records/
    assert_obj_saved @lesson
    @lesson.is_public = true
    assert @lesson.valid?
    assert_invalid @lesson, :copied_not_modified, true, false, /can't be true if public/
    assert_obj_saved @lesson
  end
  
  test 'token_length' do
    assert_obj_saved @lesson
    old_token = @lesson.token
    assert_invalid @lesson, :token, long_string(21), old_token, /is the wrong length/
    assert_invalid @lesson, :token, long_string(19), old_token, /is the wrong length/
    assert_obj_saved @lesson
  end
  
  test 'impossible_changes' do
    @lesson.parent_id = 1
    assert_obj_saved @lesson
    assert_invalid @lesson, :user_id, 2, 1, /can't be changed/
    old_token = @lesson.token
    last_char = old_token.split(old_token.chop)[1]
    different_token = last_char == 'a' ? "#{old_token.chop}b" : "#{old_token.chop}b"
    assert_equal 20, different_token.length
    assert different_token != old_token
    assert_invalid @lesson, :token, different_token, old_token, /can't be changed/
    assert_invalid @lesson, :parent_id, 2, 1, /can't be changed/
    assert_obj_saved @lesson
  end
  
end
