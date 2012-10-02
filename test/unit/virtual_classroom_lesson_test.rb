require 'test_helper'

class VirtualClassroomLessonTest < ActiveSupport::TestCase
  
  def setup
    @lesson = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
    @lesson.copied_not_modified = false
    @lesson.user_id = 2
    @lesson.save
    begin
      @virtual_classroom_lesson = VirtualClassroomLesson.new :position => 1
      @virtual_classroom_lesson.user_id = 2
      @virtual_classroom_lesson.lesson_id = @lesson.id
    rescue ActiveModel::MassAssignmentSecurity::Error
      @virtual_classroom_lesson = nil
    end
  end
  
#  test 'empty_and_defaults' do
#    @virtual_classroom_lesson = VirtualClassroomLesson.new
#    assert_error_size 1, @virtual_classroom_lesson
#  end
  
  test 'attr_accessible' do
    assert !@virtual_classroom_lesson.nil?
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {VirtualClassroomLesson.new(:user_id => 1)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {VirtualClassroomLesson.new(:lesson_id => 1)}
  end
  
 # test 'types' do
 #   assert_invalid @virtual_classroom_lesson, :description, long_string(256), long_string(255), /is too long/
 #   assert_obj_saved @virtual_classroom_lesson
 # end
  
  test 'association_methods' do
    assert_nothing_raised {@virtual_classroom_lesson.user}
    assert_nothing_raised {@virtual_classroom_lesson.lesson}
  end
  
end
