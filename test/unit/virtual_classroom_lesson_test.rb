require 'test_helper'

class VirtualClassroomLessonTest < ActiveSupport::TestCase
  
  def setup
    @lesson = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
    @lesson.copied_not_modified = false
    @lesson.user_id = 2
    @lesson.save
    begin
      @virtual_classroom_lesson = VirtualClassroomLesson.new :position => nil
      @virtual_classroom_lesson.user_id = 2
      @virtual_classroom_lesson.lesson_id = @lesson.id
    rescue ActiveModel::MassAssignmentSecurity::Error
      @virtual_classroom_lesson = nil
    end
  end
  
  test 'empty_and_defaults' do
    @virtual_classroom_lesson = VirtualClassroomLesson.new
    assert_error_size 6, @virtual_classroom_lesson
  end
  
  test 'attr_accessible' do
    assert !@virtual_classroom_lesson.nil?
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {VirtualClassroomLesson.new(:user_id => 1)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {VirtualClassroomLesson.new(:lesson_id => 1)}
  end
  
  test 'types' do
    assert_invalid @virtual_classroom_lesson, :user_id, 'ty', 2, /is not a number/
    assert_invalid @virtual_classroom_lesson, :user_id, -1, 2, /must be greater than 0/
    assert_invalid @virtual_classroom_lesson, :lesson_id, 1.5, @lesson.id, /must be an integer/
    assert_invalid @virtual_classroom_lesson, :position, (1...34), nil, /is not a number/
    assert_invalid @virtual_classroom_lesson, :position, -5, nil, /must be greater than 0/
    assert_invalid @virtual_classroom_lesson, :position, 1.5, nil, /must be an integer/
    assert_obj_saved @virtual_classroom_lesson
  end
  
  test 'association_methods' do
    assert_nothing_raised {@virtual_classroom_lesson.user}
    assert_nothing_raised {@virtual_classroom_lesson.lesson}
  end
  
  test 'associations' do
    assert_invalid @virtual_classroom_lesson, :user_id, 1000, 2, /doesn't exist/
    assert_invalid @virtual_classroom_lesson, :lesson_id, 1000, @lesson.id, /doesn't exist/
    assert_obj_saved @virtual_classroom_lesson
  end
  
  test 'uniqueness' do
    # I test uniqueness of presence in virtualclassroom
    @virtual_classroom_lesson.user_id = 1
    @virtual_classroom_lesson.lesson_id = 2
    assert !@virtual_classroom_lesson.save, "VirtualClassroomLesson erroneously saved - #{@virtual_classroom_lesson.inspect}"
    assert_equal 1, @virtual_classroom_lesson.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@virtual_classroom_lesson.errors.inspect}"
    assert_equal 1, @virtual_classroom_lesson.errors.size
    assert_match /has already been taken/, @virtual_classroom_lesson.errors.messages[:lesson_id].first
    @virtual_classroom_lesson.lesson_id = @lesson.id
    @virtual_classroom_lesson.user_id = 2
    assert @virtual_classroom_lesson.valid?, "VirtualClassroomLesson not valid: #{@virtual_classroom_lesson.errors.inspect}"
    # I create a bookmark for the lesson created here (I make it public first) to user id = 1
    @lesson.is_public = true
    assert_obj_saved @lesson
    @bookmark = Bookmark.new
    @bookmark.user_id = 1
    @bookmark.bookmarkable_id = @lesson.id
    @bookmark.bookmarkable_type = 'Lesson'
    assert_obj_saved @bookmark
    @virtual_classroom_lesson.user_id = 1
    assert_equal @lesson.id, @virtual_classroom_lesson.lesson_id
    assert_obj_saved @virtual_classroom_lesson
    @virtual_classroom_lesson.position = 1
    assert !@virtual_classroom_lesson.save, "VirtualClassroomLesson erroneously saved - #{@virtual_classroom_lesson.inspect}"
    assert_equal 1, @virtual_classroom_lesson.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@virtual_classroom_lesson.errors.inspect}"
    assert_equal 1, @virtual_classroom_lesson.errors.size
    assert_match /has already been taken/, @virtual_classroom_lesson.errors.messages[:position].first
    @virtual_classroom_lesson.position = 2
    assert @virtual_classroom_lesson.valid?, "VirtualClassroomLesson not valid: #{@virtual_classroom_lesson.errors.inspect}"
    assert_obj_saved @virtual_classroom_lesson
  end
  
  test 'availability' do
    assert_invalid @virtual_classroom_lesson, :lesson_id, 1, @lesson.id, /is not available/
    lesson1 = Lesson.find(1)
    assert !lesson1.is_public
    lesson1.is_public = true
    assert_obj_saved lesson1
    assert_invalid @virtual_classroom_lesson, :lesson_id, 1, @lesson.id, /is not available/
    assert_obj_saved @virtual_classroom_lesson
  end
  
end
