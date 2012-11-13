require 'test_helper'

class MediaElementsSlideTest < ActiveSupport::TestCase
  
  def get_new_slide kind
    if @position == nil
      @position = 2
    else
      @position += 1
    end
    @new_slide = Slide.new :position => @position
    @new_slide.lesson_id = 1
    @new_slide.kind = kind
    @new_slide.save
  end
  
  def setup
    get_new_slide 'video1'
    begin
      @media_elements_slide = MediaElementsSlide.new :position => 1
      @media_elements_slide.slide_id = @new_slide.id
      @media_elements_slide.media_element_id = 2
    rescue ActiveModel::MassAssignmentSecurity::Error
      @media_elements_slide = nil
    end
  end
  
  test 'empty_and_defaults' do
    assert !@new_slide.new_record?
    @media_elements_slide = MediaElementsSlide.new
    assert_error_size 7, @media_elements_slide
  end
  
  test 'attr_accessible' do
    assert !@media_elements_slide.nil?
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {MediaElementsSlide.new(:slide_id => 1)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {MediaElementsSlide.new(:media_element_id => 1)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {MediaElementsSlide.new(:alignment => 1)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {MediaElementsSlide.new(:caption => 1)}
  end
  
  test 'types' do
    assert_invalid @media_elements_slide, :position, 5, 1, /is not included in the list/
    @media_elements_slide.alignment = nil
    assert @media_elements_slide.valid?
    get_new_slide 'image1'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 6
    assert_invalid @media_elements_slide, :alignment, 'r', 1, /is not a number/
    assert_invalid @media_elements_slide, :alignment, 5.5, 1, /must be an integer/
    @media_elements_slide.alignment = 0
    assert @media_elements_slide.valid?
    @media_elements_slide.alignment = -8
    assert @media_elements_slide.valid?
    assert_invalid @media_elements_slide, :media_element_id, 'y3', 6, /is not a number/
    assert_invalid @media_elements_slide, :slide_id, 3.4, @new_slide.id, /must be an integer/
    assert_invalid @media_elements_slide, :slide_id, -3, @new_slide.id, /must be greater than 0/
    assert_obj_saved @media_elements_slide
  end
  
  test 'association_methods' do
    assert_nothing_raised {@media_elements_slide.media_element}
    assert_nothing_raised {@media_elements_slide.slide}
  end
  
  test 'alignment_and_caption' do
    assert_invalid @media_elements_slide, :caption, 'dgsbkj', ' ', /must be null if the element is not an image/
    assert_invalid @media_elements_slide, :alignment, 10, nil, /must be null if the element is not an image/
    get_new_slide 'image3'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 6
    assert_invalid @media_elements_slide, :alignment, nil, -1, /can't be null if the element is an image/
    assert_obj_saved @media_elements_slide
  end
  
  test 'uniqueness' do
    # I start simulating assert_invalid
    @media_elements_slide.slide_id = 4
    assert_equal 1, @media_elements_slide.position
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.size
    assert_match /has already been taken/, @media_elements_slide.errors.messages[:position].first
    @media_elements_slide.slide_id = @new_slide.id
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    # until here
    assert_obj_saved @media_elements_slide
  end
  
  test 'associations' do
    assert_invalid @media_elements_slide, :slide_id, 1000, @new_slide.id, /doesn't exist/
    assert_invalid @media_elements_slide, :media_element_id, 1000, 2, /doesn't exist/
    assert_obj_saved @media_elements_slide
  end
  
  test 'type_in_slide' do
    @media_elements_slide.media_element_id = 4
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    get_new_slide 'video2'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 4
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    # Here I have to create a new cover slide
    @lesson = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
    @lesson.copied_not_modified = false
    @lesson.user_id = 1
    @lesson.tags = 'pippo, pluto, paperino, topolino'
    assert_obj_saved @lesson
    @new_slide = Slide.where(:lesson_id => @lesson.id).first
    assert_equal 'cover', @new_slide.kind
    @media_elements_slide.slide_id = @new_slide.id
    # until here
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    @media_elements_slide.media_element_id = 4
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    get_new_slide 'image1'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    @media_elements_slide.media_element_id = 4
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    get_new_slide 'image2'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    @media_elements_slide.media_element_id = 4
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    get_new_slide 'image3'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    @media_elements_slide.media_element_id = 4
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    get_new_slide 'image4'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    @media_elements_slide.media_element_id = 4
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    get_new_slide 'audio'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 4
    @media_elements_slide.alignment = nil
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages[:media_element_id].length
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 4
    @media_elements_slide.alignment = nil
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    get_new_slide 'text'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.size
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 4
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.size
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.size
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    get_new_slide 'title'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.size
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 4
    @media_elements_slide.alignment = nil
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.size
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert !@media_elements_slide.save, "MediaElementsSlide erroneously saved - #{@media_elements_slide.inspect}"
    assert_equal 1, @media_elements_slide.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_elements_slide.errors.inspect}"
    assert_equal 1, @media_elements_slide.errors.size
    assert_match /is not compatible with the kind of slide/, @media_elements_slide.errors.messages[:media_element_id].first
    get_new_slide 'video1'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert_obj_saved @media_elements_slide
  end
  
  test 'position' do
    get_new_slide 'image1'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert_invalid @media_elements_slide, :position, 2, 1, /can't have two media elements if slide is not of the kinds 'image2', 'image4'/
    assert_invalid @media_elements_slide, :position, 3, 1, /can't have more than two media elements if slide is not of the kind 'image4'/
    assert_invalid @media_elements_slide, :position, 4, 1, /can't have more than two media elements if slide is not of the kind 'image4'/
    get_new_slide 'image3'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert_invalid @media_elements_slide, :position, 2, 1, /can't have two media elements if slide is not of the kinds 'image2', 'image4'/
    assert_invalid @media_elements_slide, :position, 3, 1, /can't have more than two media elements if slide is not of the kind 'image4'/
    assert_invalid @media_elements_slide, :position, 4, 1, /can't have more than two media elements if slide is not of the kind 'image4'/
    get_new_slide 'audio'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 4
    @media_elements_slide.alignment = nil
    assert_invalid @media_elements_slide, :position, 2, 1, /can't have two media elements if slide is not of the kinds 'image2', 'image4'/
    assert_invalid @media_elements_slide, :position, 3, 1, /can't have more than two media elements if slide is not of the kind 'image4'/
    assert_invalid @media_elements_slide, :position, 4, 1, /can't have more than two media elements if slide is not of the kind 'image4'/
    get_new_slide 'video1'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert_invalid @media_elements_slide, :position, 2, 1, /can't have two media elements if slide is not of the kinds 'image2', 'image4'/
    assert_invalid @media_elements_slide, :position, 3, 1, /can't have more than two media elements if slide is not of the kind 'image4'/
    assert_invalid @media_elements_slide, :position, 4, 1, /can't have more than two media elements if slide is not of the kind 'image4'/
    get_new_slide 'video2'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 2
    @media_elements_slide.alignment = nil
    assert_invalid @media_elements_slide, :position, 2, 1, /can't have two media elements if slide is not of the kinds 'image2', 'image4'/
    assert_invalid @media_elements_slide, :position, 3, 1, /can't have more than two media elements if slide is not of the kind 'image4'/
    assert_invalid @media_elements_slide, :position, 4, 1, /can't have more than two media elements if slide is not of the kind 'image4'/
    # Here I have to create a new cover slide
    @lesson = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
    @lesson.copied_not_modified = false
    @lesson.user_id = 1
    @lesson.tags = 'pippo, pluto, paperino, topolino'
    assert_obj_saved @lesson
    @new_slide = Slide.where(:lesson_id => @lesson.id).first
    assert_equal 'cover', @new_slide.kind
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.media_element_id = 6
    @media_elements_slide.alignment = 0
    assert_invalid @media_elements_slide, :position, 2, 1, /can't have two media elements if slide is not of the kinds 'image2', 'image4'/
    assert_invalid @media_elements_slide, :position, 3, 1, /can't have more than two media elements if slide is not of the kind 'image4'/
    assert_invalid @media_elements_slide, :position, 4, 1, /can't have more than two media elements if slide is not of the kind 'image4'/
    # until here
    get_new_slide 'image2'
    @media_elements_slide.slide_id = @new_slide.id
    assert_invalid @media_elements_slide, :position, 3, 1, /can't have more than two media elements if slide is not of the kind 'image4'/
    assert_invalid @media_elements_slide, :position, 4, 1, /can't have more than two media elements if slide is not of the kind 'image4'/
    @media_elements_slide.position = 2
    assert @media_elements_slide.valid?
    get_new_slide 'image4'
    @media_elements_slide.slide_id = @new_slide.id
    @media_elements_slide.position = 2
    assert @media_elements_slide.valid?
    @media_elements_slide.position = 3
    assert @media_elements_slide.valid?
    @media_elements_slide.position = 4
    assert_obj_saved @media_elements_slide
  end
  
  test 'availability' do
    media = MediaElement.find(1)
    assert !media.is_public && media.user_id == 1
    media = MediaElement.find(3)
    assert !media.is_public && media.user_id != 1
    assert_equal 1, @new_slide.lesson.user_id
    @media_elements_slide.media_element_id = 1
    assert @media_elements_slide.valid?, "MediaElementsSlide not valid: #{@media_elements_slide.errors.inspect}"
    get_new_slide 'audio'
    assert_equal 1, @new_slide.lesson.user_id
    @media_elements_slide.slide_id = @new_slide.id
    assert_invalid @media_elements_slide, :media_element_id, 3, 4, /is not available/
    assert_obj_saved @media_elements_slide
  end
  
  test 'impossible_changes' do
    assert_obj_saved @media_elements_slide
    old_slide_id = @new_slide.id
    get_new_slide 'video1'
    assert_invalid @media_elements_slide, :slide_id, @new_slide.id, old_slide_id, /can't be changed/
  end
  
end
