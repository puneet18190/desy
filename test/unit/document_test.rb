# encoding: UTF-8
require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  
  def setup
    @max_title = I18n.t('language_parameters.document.length_title')
    @max_description = I18n.t('language_parameters.document.length_description')
    begin
      @document = Document.new :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato', :attachment => File.open(Rails.root.join('test/samples/one.ppt'))
      @document.user_id = 1
    rescue ActiveModel::MassAssignmentSecurity::Error
      @document = nil
    end
  end
  
  test 'empty_and_defaults' do
    @document = Document.new
    assert_error_size 6, @document
  end
  
  test 'attr_accessible' do
    assert !@document.nil?
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Document.new(:user_id => 1)}
  end
  
  test 'types' do
    assert_invalid @document, :user_id, 'er', 1, :not_a_number
    assert_invalid @document, :user_id, 0, 2, :greater_than, {:count => 0}
    assert_invalid @document, :user_id, 0.6, 1, :not_an_integer
    assert_invalid @document, :title, long_string(@max_title + 1), long_string(@max_title), :too_long, {:count => @max_title}
    assert_invalid @document, :description, long_string(@max_description + 1), long_string(@max_description), :too_long, {:count => @max_description}
    assert_obj_saved @document
  end
  
  test 'association_methods' do
    assert_nothing_raised {@document.user}
    assert_nothing_raised {@document.documents_slides}
  end
  
  test 'associations' do
    assert_invalid @document, :user_id, 1000, 1, :doesnt_exist
    assert_obj_saved @document
  end
  
  test 'impossible_changes' do
    assert_obj_saved @document
    assert_invalid @document, :user_id, 2, 1, :cant_be_changed
    assert_obj_saved @document
  end
  
end
