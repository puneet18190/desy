require 'test_helper'

class VirtualClassroomLessonTest < ActiveSupport::TestCase
  
  def setup
    @lesson = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
    @lesson.copied_not_modified = false
    @lesson.user_id = 2
    @lesson.tags = 'topolino, pippo, pluto, paperino'
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
    assert_invalid @virtual_classroom_lesson, :user_id, 'ty', 2, :not_a_number
    assert_invalid @virtual_classroom_lesson, :user_id, -1, 2, :greater_than, {:count => 0}
    assert_invalid @virtual_classroom_lesson, :lesson_id, 1.5, @lesson.id, :not_an_integer
    assert_invalid @virtual_classroom_lesson, :position, 'iii', nil, :not_a_number
    assert_invalid @virtual_classroom_lesson, :position, -5, nil, :greater_than, {:count => 0}
    assert_invalid @virtual_classroom_lesson, :position, 1.5, nil, :not_an_integer
    assert_obj_saved @virtual_classroom_lesson
  end
  
  test 'association_methods' do
    assert_nothing_raised {@virtual_classroom_lesson.user}
    assert_nothing_raised {@virtual_classroom_lesson.lesson}
  end
  
  test 'associations' do
    assert_invalid @virtual_classroom_lesson, :user_id, 1000, 2, :doesnt_exist
    assert_invalid @virtual_classroom_lesson, :lesson_id, 1000, @lesson.id, :doesnt_exist
    assert_obj_saved @virtual_classroom_lesson
  end
  
  test 'uniqueness' do
    # I test uniqueness of presence in virtualclassroom
    @virtual_classroom_lesson.user_id = 1
    @virtual_classroom_lesson.lesson_id = 2
    assert !@virtual_classroom_lesson.save, "VirtualClassroomLesson erroneously saved - #{@virtual_classroom_lesson.inspect}"
    assert_equal 1, @virtual_classroom_lesson.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@virtual_classroom_lesson.errors.inspect}"
    assert_equal 1, @virtual_classroom_lesson.errors.size
    assert @virtual_classroom_lesson.errors.added? :lesson_id, :taken
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
    assert @virtual_classroom_lesson.errors.added? :position, :taken
    @virtual_classroom_lesson.position = 2
    assert @virtual_classroom_lesson.valid?, "VirtualClassroomLesson not valid: #{@virtual_classroom_lesson.errors.inspect}"
    assert_obj_saved @virtual_classroom_lesson
  end
  
  test 'availability' do
    assert_invalid @virtual_classroom_lesson, :lesson_id, 1, @lesson.id, :is_not_available
    lesson1 = Lesson.find(1)
    assert !lesson1.is_public
    lesson1.is_public = true
    assert_obj_saved lesson1
    assert_invalid @virtual_classroom_lesson, :lesson_id, 1, @lesson.id, :is_not_available
    assert_obj_saved @virtual_classroom_lesson
  end
  
  test 'copied_not_modified' do
    @lesson.copied_not_modified = true
    assert_obj_saved @lesson
    assert !@virtual_classroom_lesson.save, "VirtualClassroomLesson erroneously saved - #{@virtual_classroom_lesson.inspect}"
    assert_equal 1, @virtual_classroom_lesson.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@virtual_classroom_lesson.errors.inspect}"
    assert_equal 1, @virtual_classroom_lesson.errors.size
    assert @virtual_classroom_lesson.errors.added? :lesson_id, :just_been_copied
    @lesson.copied_not_modified = false
    assert_obj_saved @lesson
    assert @virtual_classroom_lesson.valid?, "VirtualClassroomLesson not valid: #{@virtual_classroom_lesson.errors.inspect}"
  end
  
  test 'positions' do
    assert_invalid @virtual_classroom_lesson, :position, 1, nil, :must_be_null_if_new_record
    assert_obj_saved @virtual_classroom_lesson
  end
  
  test 'impossible_changes' do
    assert_obj_saved @virtual_classroom_lesson
    @virtual_classroom_lesson.user_id = 1
    assert !@virtual_classroom_lesson.save, "VirtualClassroomLesson erroneously saved - #{@virtual_classroom_lesson.inspect}"
    assert_equal 2, @virtual_classroom_lesson.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@virtual_classroom_lesson.errors.inspect}"
    assert_equal 2, @virtual_classroom_lesson.errors.size
    assert @virtual_classroom_lesson.errors.added? :user_id, :cant_be_changed
    @virtual_classroom_lesson.user_id = 2
    assert @virtual_classroom_lesson.valid?, "VirtualClassroomLesson not valid: #{@virtual_classroom_lesson.errors.inspect}"
    assert_invalid @virtual_classroom_lesson, :lesson_id, 1, @lesson.id, :cant_be_changed
    assert_obj_saved @virtual_classroom_lesson
  end
  
  test 'playlist_size' do
    Lesson.where(:user_id => 1).each do |l|
      l.destroy
    end
    VirtualClassroomLesson.where(:user_id => 1).each do |vcl|
      vcl.destroy
    end
    assert Lesson.where(:user_id => 1).empty?
    assert VirtualClassroomLesson.where(:user_id => 1).empty?
    user = User.find 1
    (0...20).each do |i|
      x = user.create_lesson "title_#{i}", "description_#{i}", 1, 'paperino, pippo, pluto, topolino'
      assert x
      assert x.add_to_virtual_classroom 1
      vc = VirtualClassroomLesson.where(:user_id => 1, :lesson_id => x.id).first
      assert vc.add_to_playlist, "Failed adding to playlist the lesson #{vc.lesson.inspect}"
    end
    assert_equal 20, Lesson.where(:user_id => 1).count
    assert_equal 20, VirtualClassroomLesson.where(:user_id => 1).count
    assert_equal 20, user.playlist.length
    x = user.create_lesson "title_20", "description_20", 1, 'paperino, pippo, pluto, topolino'
    assert x
    assert x.add_to_virtual_classroom 1
    vc = VirtualClassroomLesson.where(:user_id => 1, :lesson_id => x.id).first
    assert vc.position.nil?
    assert_invalid vc, :position, 21, nil, :reached_maximum_in_playlist
    assert_obj_saved vc
  end
  
end
