# encoding: UTF-8
require 'test_helper'

class DocumentsSlideTest < ActiveSupport::TestCase
  
  def setup
    begin
      @documents_slide = DocumentsSlide.new
      @documents_slide.document_id = 1
      @documents_slide.slide_id = 2
    rescue ActiveModel::MassAssignmentSecurity::Error
      @documents_slide = nil
    end
  end
  
  test 'empty_and_defaults' do
    @documents_slide = DocumentsSlide.new
    assert_error_size 6, @documents_slide
  end
  
  test 'attr_accessible' do
    assert !@documents_slide.nil?
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {DocumentsSlide.new(:document_id => 1)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {DocumentsSlide.new(:slide_id => 1)}
  end
  
  test 'types' do
    assert_invalid @documents_slide, :document_id, 'er', 1, :not_a_number
    assert_invalid @documents_slide, :slide_id, 0, 2, :greater_than, {:count => 0}
    assert_invalid @documents_slide, :slide_id, 0.6, 2, :not_an_integer
    assert_obj_saved @documents_slide
  end
  
  test 'association_methods' do
    assert_nothing_raised {@documents_slide.document}
    assert_nothing_raised {@documents_slide.slide}
  end
  
  test 'associations' do
    assert_invalid @documents_slide, :document_id, 1000, 1, :doesnt_exist
    assert_invalid @documents_slide, :slide_id, 1000, 2, :doesnt_exist
    assert_obj_saved @documents_slide
  end
  
  test 'impossible_changes' do
    @doc = Document.new :title => 'oo', :description => 'volare'
    @doc.user_id = 1
    assert_obj_saved @doc
    @slide = Lesson.last.add_slide 'title', 2
    assert_not_nil @slide
    assert_obj_saved @documents_slide
    assert_invalid @documents_slide, :document_id, @doc.id, 1, :cant_be_changed
    assert_invalid @documents_slide, :slide_id, @slide.id, 2, :cant_be_changed
    @documents_slide.document_id = 1
    assert_obj_saved @documents_slide
  end
  
  test 'uniqueness' do
    assert_invalid @documents_slide, :document_id, 2, 1, :taken
    assert_obj_saved @documents_slide
  end
  
end
