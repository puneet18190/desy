require 'test_helper'

class SlideTest < ActiveSupport::TestCase
  
  def setup
    begin
      @slide = Slide.new :position => 2, :title => 'Titolo', :text => 'Testo testo testo'
      @slide.lesson_id = 1
      @slide.kind = 'video1'
    rescue ActiveModel::MassAssignmentSecurity::Error
      @slide = nil
    end
  end
  
  test 'empty_and_defaults' do
    @slide = Slide.new
    assert_error_size 6, @slide
  end
  
  test 'attr_accessible' do
    assert !@slide.nil?
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Slide.new(:kind => 'image2')}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Slide.new(:lesson_id => 2)}
  end
  
  test 'types' do
    assert_invalid @slide, :position, 'ret', 2, :not_a_number
    assert_invalid @slide, :position, -9, 2, :greater_than, {:count => 0}
    assert_invalid @slide, :lesson_id, 1.1, 1, :not_an_integer
    @slide.kind = 'audio3'
    assert !@slide.save, "Slide erroneously saved - #{@slide.inspect}"
    assert_equal 3, @slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@slide.errors.inspect}"
    assert_equal 1, @slide.errors.messages[:kind].length
    assert @slide.errors.added? :kind, :inclusion
    @slide.kind = 'video1'
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    assert_invalid @slide, :title, long_string(256), long_string(255), :too_long, {:count => 255}
    @slide.title = nil
    assert_obj_saved @slide
  end
  
  test 'association_methods' do
    assert_nothing_raised {@slide.media_elements_slides}
    assert_nothing_raised {@slide.lesson}
    assert_nothing_raised {@slide.documents_slides}
  end
  
  test 'uniqueness' do
    @slide.lesson_id = 2
    assert_invalid @slide, :position, 2, 4, :taken
    # I rewrite manually assert_invalid
    @slide.kind = 'cover'
    old_text = @slide.text
    @slide.text = nil
    assert !@slide.save, "Slide erroneously saved - #{@slide.inspect}"
    assert_equal 2, @slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@slide.errors.inspect}"
    assert @slide.errors.added? :kind, :taken
    @slide.kind = 'video1'
    @slide.text = old_text
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    # until here
    assert_obj_saved @slide
    assert_equal 2, Slide.where(:lesson_id => 2, :kind => 'video1').count
  end
  
  test 'associations' do
    assert_invalid @slide, :lesson_id, 1000, 1, :doesnt_exist
    assert_obj_saved @slide
  end
  
  test 'impossible_changes' do
    assert_obj_saved @slide
    # I rewrite manually assert_invalid
    @slide.position = 4
    @slide.lesson_id = 2
    assert !@slide.save, "Slide erroneously saved - #{@slide.inspect}"
    assert_equal 1, @slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@slide.errors.inspect}"
    assert @slide.errors.added? :lesson_id, :cant_be_changed
    @slide.lesson_id = 1
    @slide.position = 2
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    # until here
    assert_invalid @slide, :kind, 'audio', 'video1', :cant_be_changed
    assert_obj_saved @slide
  end
  
  test 'cover' do
    assert_invalid @slide, :position, 1, 2, :if_not_cover_cant_be_first_slide
    assert_obj_saved @slide
    @slide = Slide.find 1
    assert_equal 'cover', @slide.kind
    assert_invalid @slide, :position, 3, 1, :cover_must_be_first_slide
    assert_obj_saved @slide
  end
  
  test 'destruction' do
    @slide = Slide.find 1
    @slide.destroy
    assert Slide.exists?(1)
    @lesson = Lesson.find 1
    @lesson.destroy
    assert !Lesson.exists?(1)
    assert !Slide.exists?(1)
  end
  
  test 'blank_text_and_title' do
    @slide.kind = 'video2'
    @slide.text = 'ciao ciao ciao'
    assert !@slide.save, "Slide erroneously saved - #{@slide.inspect}"
    assert_equal 2, @slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@slide.errors.inspect}"
    assert_equal 1, @slide.errors.messages[:title].length
    assert_equal 1, @slide.errors.messages[:text].length
    assert @slide.errors.added? :title, :must_be_null_in_this_slide
    assert @slide.errors.added? :text, :must_be_null_in_this_slide
    @slide.text = nil
    @slide.title = nil
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    @slide.kind = 'image2'
    @slide.title = 'beh'
    @slide.text = 'ciao ciao ciao'
    assert !@slide.save, "Slide erroneously saved - #{@slide.inspect}"
    assert_equal 2, @slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@slide.errors.inspect}"
    assert_equal 1, @slide.errors.messages[:title].length
    assert_equal 1, @slide.errors.messages[:text].length
    assert @slide.errors.added? :title, :must_be_null_in_this_slide
    assert @slide.errors.added? :text, :must_be_null_in_this_slide
    @slide.text = nil
    @slide.title = nil
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    @slide.kind = 'image3'
    @slide.title = 'beh'
    @slide.text = 'ciao ciao ciao'
    assert !@slide.save, "Slide erroneously saved - #{@slide.inspect}"
    assert_equal 2, @slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@slide.errors.inspect}"
    assert_equal 1, @slide.errors.messages[:title].length
    assert_equal 1, @slide.errors.messages[:text].length
    assert @slide.errors.added? :title, :must_be_null_in_this_slide
    assert @slide.errors.added? :text, :must_be_null_in_this_slide
    @slide.text = nil
    @slide.title = nil
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    @slide.kind = 'image4'
    @slide.title = 'beh'
    @slide.text = 'ciao ciao ciao'
    assert !@slide.save, "Slide erroneously saved - #{@slide.inspect}"
    assert_equal 2, @slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@slide.errors.inspect}"
    assert_equal 1, @slide.errors.messages[:title].length
    assert_equal 1, @slide.errors.messages[:text].length
    assert @slide.errors.added? :title, :must_be_null_in_this_slide
    assert @slide.errors.added? :text, :must_be_null_in_this_slide
    @slide.text = nil
    @slide.title = nil
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    @slide.kind = 'title'
    @slide.title = 'beh'
    @slide.text = 'ciao ciao ciao'
    assert !@slide.save, "Slide erroneously saved - #{@slide.inspect}"
    assert_equal 1, @slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@slide.errors.inspect}"
    assert_equal 1, @slide.errors.messages[:text].length
    assert @slide.errors.added? :text, :must_be_null_in_this_slide
    @slide.text = nil
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    temmmporary_lesson = Lesson.first
    @slide = temmmporary_lesson.slides.first
    @slide.title = temmmporary_lesson.title
    @slide.text = 'ciao ciao ciao'
    assert !@slide.save, "Slide erroneously saved - #{@slide.inspect}"
    assert_equal 1, @slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@slide.errors.inspect}"
    assert_equal 1, @slide.errors.messages[:text].length
    assert @slide.errors.added? :text, :must_be_null_in_this_slide
    @slide.text = nil
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    assert_obj_saved @slide
  end
  
  test 'cover_title_different_by_lesson_title' do
    lesson = Lesson.find(1)
    cover = lesson.cover
    assert_equal cover.title, lesson.title
    assert_invalid cover, :title, 'tstrong', 'tstring', :in_cover_it_cant_be_different_by_lessons_title
    lesson.title = 'buahuahua'
    assert_obj_saved lesson
    cover = Slide.find cover.id
    assert_equal 'buahuahua', cover.title
  end
  
  test 'maximum_slides' do
    l = Lesson.find 1
    assert_equal 1, Slide.where(:lesson_id => l.id).count
    (2...100).to_a.each do |i|
      assert_not_nil l.add_slide('text', i)
    end
    s = Slide.new
    s.position = 100
    s.lesson_id = l.id
    s.kind = 'text'
    assert !s.save, "#Slide erroneously saved - #{s.inspect}"
    assert_equal 1, s.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{s.errors.inspect}"
    assert_equal 1, s.errors.messages[:base].length
    assert s.errors.added? :base, :too_many_slides
    s2 = Slide.where(:position => 80).first
    assert s2.valid?
    s2.destroy
    assert_obj_saved s
  end
  
  test 'adhiacent_slides' do
    vcl2 = VirtualClassroomLesson.first
    vcl1 = VirtualClassroomLesson.new
    vcl1.user_id = 1
    vcl1.lesson_id = 1
    assert_obj_saved vcl1
    l1 = Lesson.find(1)
    assert_equal 1, l1.slides.count
    l2 = Lesson.find(2)
    assert_equal 3, l2.slides.count
    assert_equal l1.id, vcl1.lesson_id
    assert_equal l2.id, vcl2.lesson_id
    s = l2.cover.following
    assert_equal 2, s.position
    # normale da dx a sx e viceversa in playlist
    assert_equal 4, s.get_adhiacent_slide_in_lesson_viewer(1, true, false).id
    assert_equal 2, s.get_adhiacent_slide_in_lesson_viewer(1, true, true).id
    # normale da dx a sx e viceversa non in playlist
    assert_equal 4, s.get_adhiacent_slide_in_lesson_viewer(1, false, false).id
    assert_equal 2, s.get_adhiacent_slide_in_lesson_viewer(1, false, true).id
    # dalla fine all'inizio in playlist
    s = Slide.find(4)
    assert_equal 2, s.get_adhiacent_slide_in_lesson_viewer(1, true, false).id
    # idem non in playlist
    assert_equal 2, s.get_adhiacent_slide_in_lesson_viewer(1, false, false).id
    # dall'inizio alla fine in playlist
    s = Slide.find(2)
    assert_equal 4, s.get_adhiacent_slide_in_lesson_viewer(1, true, true).id
    # idem non in playlist
    assert_equal 4, s.get_adhiacent_slide_in_lesson_viewer(1, false, true).id
    # dalla slide a se stessa fuori playlist
    s = Slide.find(1)
    assert_equal 1, s.get_adhiacent_slide_in_lesson_viewer(1, false, true).id
    assert_equal 1, s.get_adhiacent_slide_in_lesson_viewer(1, false, false).id
    # dalla slide a se stessa in playlist
    assert vcl2.remove_from_playlist
    assert vcl1.add_to_playlist
    assert_equal 1, s.get_adhiacent_slide_in_lesson_viewer(1, true, true).id
    assert_equal 1, s.get_adhiacent_slide_in_lesson_viewer(1, true, false).id
    # da lezione alla successiva in playlist (x4 casi)
    assert vcl2.add_to_playlist
    assert_equal 2, s.get_adhiacent_slide_in_lesson_viewer(1, true, false).id
    assert_equal 4, s.get_adhiacent_slide_in_lesson_viewer(1, true, true).id
    s = Slide.find(4)
    # da lezione alla successiva in playlist
    assert_equal 1, s.get_adhiacent_slide_in_lesson_viewer(1, true, false).id
    s = Slide.find(2)
    assert_equal 1, s.get_adhiacent_slide_in_lesson_viewer(1, true, true).id
    # ignoro la playlist
    assert_equal 4, s.get_adhiacent_slide_in_lesson_viewer(1, false, true).id
    s = Slide.find(4)
    assert_equal 2, s.get_adhiacent_slide_in_lesson_viewer(1, false, false).id
    assert vcl2.remove_from_playlist
    assert_nil s.get_adhiacent_slide_in_lesson_viewer(1, true, false)
    VirtualClassroomLesson.delete_all
    assert VirtualClassroomLesson.all.empty?
    assert_nil s.get_adhiacent_slide_in_lesson_viewer(1, true, false)
  end
  
end
