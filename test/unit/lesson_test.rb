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
    assert_error_size 13, @lesson
  end
  
  test 'attr_accessible' do
    assert !@lesson.nil?
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Lesson.new(:is_public => true)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Lesson.new(:copied_not_modified => true)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Lesson.new(:parent_id => 2)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Lesson.new(:user_id => 1)}
  end
  
  #test 'types' do
  ##  assert_invalid @lesson, :description, long_string(256), long_string(255), /is too long/
  #  assert_obj_saved @lesson
 # end
  
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
  
end
