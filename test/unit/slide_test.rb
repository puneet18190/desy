require 'test_helper'

class SlideTest < ActiveSupport::TestCase
  
  def setup
    begin
      @slide = Slide.new :position => 2, :title => 'Titolo', :text1 => 'Testo testo testo'
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
    assert_invalid @slide, :kind, 'image4', 'video1', /is not included in the list/
    assert_invalid @slide, :title, long_string(256), long_string(255), /is too long/
    @slide.title = nil
    assert_obj_saved @slide
  end
  
  test 'association_methods' do
    assert_nothing_raised {@slide.media_elements_slides}
    assert_nothing_raised {@slide.lesson}
  end
  
# nel test della callback before destroy per la copertina, anche metti un ok_destruction test che mi permette di verificare che posso cancellare la slide e nient'altro! ++ metti nei fixtures una copertina per ogni lezione già caricata!
  
end
