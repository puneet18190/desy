require 'test_helper'

class MediaElementsSlideTest < ActiveSupport::TestCase
  
  def setup
    @new_slide = Slide.new :position => 2, :title => 'Titolo', :text1 => 'Testo testo testo'
    @new_slide.lesson_id = 1
    @new_slide.kind = 'video1'
    begin
      @media_elements_slide = MediaElementsSlide.new :position => 1
      @media_elements_slide.slide_id = @new_slide.id
      @media_elements_slide.media_element_id = 2
    rescue ActiveModel::MassAssignmentSecurity::Error
      @media_elements_slide = nil
    end
  end
  
  #test 'empty_and_defaults' do
  #  @media_elements_slide = MediaElementsSlide.new
  #  assert_error_size 1, @media_elements_slide
  #end
  
  test 'attr_accessible' do
    assert !@media_elements_slide.nil?
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {MediaElementsSlide.new(:slide_id => 1)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {MediaElementsSlide.new(:media_element_id => 1)}
  end
  
 # test 'types' do
 #   assert_invalid @media_elements_slide, :description, long_string(256), long_string(255), /is too long/
  #  assert_obj_saved @media_elements_slide
  #end
  
  test 'association_methods' do
    assert_nothing_raised {@media_elements_slide.media_element}
    assert_nothing_raised {@media_elements_slide.slide}
  end
  
end
