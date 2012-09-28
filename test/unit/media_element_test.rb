require 'test_helper'

class MediaElementTest < ActiveSupport::TestCase
  
  def setup
    begin
      @media_element = MediaElement.new :description => 'Scuola Primaria', :title => 'Scuola'
      @media_element.user_id = 1
      @media_element.sti_type = 'Video'
      @media_element.duration = 10
    rescue ActiveModel::MassAssignmentSecurity::Error
      @media_element = nil
    end
  end
  
  test 'empty_and_defaults' do
    @media_element = MediaElement.new
    assert_equal false, @media_element.is_public
    @media_element.is_public = nil
    assert_error_size 8, @media_element
  end
  
  test 'attr_accessible' do
    assert !@media_element.nil?
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {MediaElement.new(:is_public => true)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {MediaElement.new(:sti_type => 'beh')}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {MediaElement.new(:user_id => 1)}
  end
  
  test 'types' do
    assert_invalid @media_element, :title, long_string(256), long_string(255), /is too long/
    assert_invalid @media_element, :user_id, 'po', 1, /is not a number/
    assert_invalid @media_element, :user_id, -3, 1, /must be greater than 0/
    assert_invalid @media_element, :user_id, 3.4, 1, /must be an integer/
    assert_invalid @media_element, :duration, 'po', 1, /is not a number/
    assert_invalid @media_element, :duration, -3, 1, /must be greater than 0/
    assert_invalid @media_element, :duration, 3.4, 1, /must be an integer/
    assert_invalid @media_element, :is_public, nil, false, /is not included in the list/
    assert_invalid @media_element, :sti_type, 'Film', 'Video', /is not included in the list/
    assert_obj_saved @media_element
  end
  
  test 'association_methods' do
    assert_nothing_raised {@media_element.bookmarks}
    assert_nothing_raised {@media_element.media_elements_slides}
    assert_nothing_raised {@media_element.reports}
    assert_nothing_raised {@media_element.taggings}
    assert_nothing_raised {@media_element.user}
  end
  
end
