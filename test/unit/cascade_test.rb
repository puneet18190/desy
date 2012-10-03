require 'test_helper'

class CascadeTest < ActiveSupport::TestCase
  
  test 'lesson_cascade' do
    @lesson = Lesson.find 2
    @copied_lesson = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
    @copied_lesson.copied_not_modified = false
    @copied_lesson.user_id = 1
    @copied_lesson.parent_id = 2
    assert_obj_saved @copied_lesson
    @tagging = Tagging.new
    @tagging.taggable_type = 'Lesson'
    @tagging.tag_id = 1
    @tagging.taggable_id = 2
    assert_obj_saved @tagging
    ids = {Bookmark => [], Like => [], Slide => [], MediaElementsSlide => [], Tagging => [], Report => [], VirtualClassroomLesson => []}
    assert_equal @lesson.id, @copied_lesson.parent.id
    assert_equal 1, @lesson.bookmarks.length
    @lesson.bookmarks.each do |b|
      ids[Bookmark] << b.id
    end
    assert_equal 1, @lesson.likes.length
    @lesson.likes.each do |b|
      ids[Like] << b.id
    end
    assert_equal 3, @lesson.slides.length
    @lesson.slides.each do |b|
      ids[Slide] << b.id
    end
    @lesson.slides.where(:id => [3, 4]).each do |s|
      assert_equal 1, s.media_elements_slides.length
      s.media_elements_slides.each do |b|
        ids[MediaElementsSlide] << b.id
      end
    end
    assert_equal 1, @lesson.taggings.length
    @lesson.taggings.each do |b|
      ids[Tagging] << b.id
    end
    assert_equal 2, @lesson.reports.length
    @lesson.reports.each do |b|
      ids[Report] << b.id
    end
    assert_equal 1, @lesson.virtual_classroom_lessons.length
    @lesson.virtual_classroom_lessons.each do |b|
      ids[VirtualClassroomLesson] << b.id
    end
    @lesson.destroy
    assert Lesson.find(@copied_lesson.id).parent_id.nil?
    ids.each do |k, v|
      assert k.where(:id => v).empty?
    end
  end
  
  test 'media_element_cascade' do
    
  end
  
  test 'tag_cascade' do
    
  end
  
  test 'bookmarks' do
    
  end
  
end
