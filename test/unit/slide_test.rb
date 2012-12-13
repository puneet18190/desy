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
    assert_invalid @slide, :position, 'ret', 2, /is not a number/
    assert_invalid @slide, :position, -9, 2, /must be greater than 0/
    assert_invalid @slide, :lesson_id, 1.1, 1, /must be an integer/
    @slide.kind = 'audio3'
    assert !@slide.save, "Slide erroneously saved - #{@slide.inspect}"
    assert_equal 3, @slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@slide.errors.inspect}"
    assert_equal 1, @slide.errors.messages[:kind].length
    assert_match /is not included in the list/, @slide.errors.messages[:kind].first
    @slide.kind = 'video1'
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    assert_invalid @slide, :title, long_string(36), long_string(35), /is too long/
    @slide.title = nil
    assert_obj_saved @slide
  end
  
  test 'association_methods' do
    assert_nothing_raised {@slide.media_elements_slides}
    assert_nothing_raised {@slide.lesson}
  end
  
  test 'uniqueness' do
    @slide.lesson_id = 2
    assert_invalid @slide, :position, 2, 4, /has already been taken/
    # I rewrite manually assert_invalid
    @slide.kind = 'cover'
    old_text = @slide.text
    @slide.text = nil
    assert !@slide.save, "Slide erroneously saved - #{@slide.inspect}"
    assert_equal 2, @slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@slide.errors.inspect}"
    assert_match /has already been taken/, @slide.errors.messages[:kind].first
    @slide.kind = 'video1'
    @slide.text = old_text
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    # until here
    assert_obj_saved @slide
    assert_equal 2, Slide.where(:lesson_id => 2, :kind => 'video1').count
  end
  
  test 'associations' do
    assert_invalid @slide, :lesson_id, 1000, 1, /doesn't exist/
    assert_obj_saved @slide
  end
  
  test 'impossible_changes' do
    assert_obj_saved @slide
    # I rewrite manually assert_invalid
    @slide.position = 4
    @slide.lesson_id = 2
    assert !@slide.save, "Slide erroneously saved - #{@slide.inspect}"
    assert_equal 1, @slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@slide.errors.inspect}"
    assert_match /can't be changed/, @slide.errors.messages[:lesson_id].first
    @slide.lesson_id = 1
    @slide.position = 2
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    # until here
    assert_invalid @slide, :kind, 'audio', 'video1', /can't be changed/
    assert_obj_saved @slide
  end
  
  test 'cover' do
    assert_invalid @slide, :position, 1, 2, /if not cover can't be the first slide/
    assert_obj_saved @slide
    @slide = Slide.find 1
    assert_equal 'cover', @slide.kind
    assert_invalid @slide, :position, 3, 1, /cover must be the first slide/
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
    assert_match /must be null for this kind of slide/, @slide.errors.messages[:title].first
    assert_match /must be null for this kind of slide/, @slide.errors.messages[:text].first
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
    assert_match /must be null for this kind of slide/, @slide.errors.messages[:title].first
    assert_match /must be null for this kind of slide/, @slide.errors.messages[:text].first
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
    assert_match /must be null for this kind of slide/, @slide.errors.messages[:title].first
    assert_match /must be null for this kind of slide/, @slide.errors.messages[:text].first
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
    assert_match /must be null for this kind of slide/, @slide.errors.messages[:title].first
    assert_match /must be null for this kind of slide/, @slide.errors.messages[:text].first
    @slide.text = nil
    @slide.title = nil
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    @slide.kind = 'title'
    @slide.title = 'beh'
    @slide.text = 'ciao ciao ciao'
    assert !@slide.save, "Slide erroneously saved - #{@slide.inspect}"
    assert_equal 1, @slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@slide.errors.inspect}"
    assert_equal 1, @slide.errors.messages[:text].length
    assert_match /must be null for this kind of slide/, @slide.errors.messages[:text].first
    @slide.text = nil
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    temmmporary_lesson = Lesson.first
    @slide = temmmporary_lesson.slides.first
    @slide.title = temmmporary_lesson.title
    @slide.text = 'ciao ciao ciao'
    assert !@slide.save, "Slide erroneously saved - #{@slide.inspect}"
    assert_equal 1, @slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@slide.errors.inspect}"
    assert_equal 1, @slide.errors.messages[:text].length
    assert_match /must be null for this kind of slide/, @slide.errors.messages[:text].first
    @slide.text = nil
    assert @slide.valid?, "Slide not valid: #{@slide.errors.inspect}"
    assert_obj_saved @slide
  end
  
  test 'cover_title_different_by_lesson_title' do
    lesson = Lesson.find(1)
    cover = lesson.cover
    assert_equal cover.title, lesson.title
    assert_invalid cover, :title, 'tstrong', 'tstring', /if cover it can't be different by lesson's title/
    lesson.title = 'buahuahua'
    assert_obj_saved lesson
    cover = Slide.find cover.id
    assert_equal 'buahuahua', cover.title
  end
  
end
