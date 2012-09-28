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
  
  test 'associations' do
    assert_invalid @media_element, :user_id, 900, 1, /doesn't exist/
    assert_obj_saved @media_element
  end
  
  test 'public' do
    # faccio a mano il lavoro di assert_invalid
    @media_element.publication_date = '2011-01-01 10:00:00'
    @media_element.is_public = true
    assert !@media_element.save, "MediaElement erroneously saved - #{@media_element.inspect}"
    assert_equal 1, @media_element.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_element.errors.inspect}"
    assert @media_element.errors.messages[:is_public].include?("must be false if new record")
    @media_element.is_public = false
    @media_element.publication_date = nil
    assert @media_element.valid?, "MediaElement not valid - #{@media_element.errors.inspect}"
    # fino a qui
    assert_obj_saved @media_element
    assert_invalid @media_element, :sti_type, 'Audio', 'Video', /is not changeable/
    assert_invalid @media_element, :user_id, 2, 1, /can't be changed/
    @media_element.title = 'Squola'
    @media_element.description = 'Squola Primaria'
    @media_element.duration = 11
    assert_invalid @media_element, :publication_date, '2011-10-10 10:10:19', nil, /must be blank if private/
    @media_element.is_public = true
    assert_invalid @media_element, :publication_date, 1, '2011-11-11 10:00:00', /is not a date/
    assert_obj_saved @media_element
    # faccio a mano il lavoro di assert_invalid
    @media_element.publication_date = nil
    @media_element.is_public = false
    assert !@media_element.save, "MediaElement erroneously saved - #{@media_element.inspect}"
    assert_equal 2, @media_element.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@media_element.errors.inspect}"
    assert @media_element.errors.messages[:is_public].include?("is not changeable for a public record")
    assert @media_element.errors.messages[:publication_date].include?("is not changeable for a public record")
    @media_element.is_public = true
    @media_element.publication_date = '2011-11-11 10:00:00'
    assert @media_element.valid?, "MediaElement not valid - #{@media_element.errors.inspect}"
    assert_invalid @media_element, :title, 'Scuola', 'Squola', /is not changeable for a public record/
    assert_invalid @media_element, :description, 'Scuola Primaria', 'Squola Primaria', /is not changeable for a public record/
    assert_invalid @media_element, :duration, 111, 11, /is not changeable for a public record/
    @media_element.user_id = 2
    assert_equal 1, MediaElement.find(@media_element.id).user_id
    assert_obj_saved @media_element
  end
  
  test 'duration' do
    assert true
  end
  
end
