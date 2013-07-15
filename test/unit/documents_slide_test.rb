# encoding: UTF-8
require 'test_helper'

class DocumentsSlideTest < ActiveSupport::TestCase
  
  def setup
    begin
      @documents_slide = DocumentsSlide.new
      @documents_slide.document_id = 1
      @documents_slide.slide_id = 4
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
    assert_invalid @documents_slide, :slide_id, 0, 4, :greater_than, {:count => 0}
    assert_invalid @documents_slide, :slide_id, 0.6, 4, :not_an_integer
    assert_obj_saved @documents_slide
  end
  
  test 'association_methods' do
    assert_nothing_raised {@documents_slide.document}
    assert_nothing_raised {@documents_slide.slide}
  end
  
  test 'associations' do
    assert_invalid @documents_slide, :document_id, 1000, 1, :doesnt_exist
    assert_invalid @documents_slide, :slide_id, 1000, 4, :doesnt_exist
    assert_obj_saved @documents_slide
  end
  
  test 'impossible_changes' do
    @doc = Document.new :title => 'oo', :description => 'volare'
    @doc.user_id = 1
    assert_obj_saved @doc
    @slide = Lesson.last.add_slide 'audio', 2
    assert_not_nil @slide
    assert_obj_saved @documents_slide
    assert_invalid @documents_slide, :document_id, @doc.id, 1, :cant_be_changed
    assert_invalid @documents_slide, :slide_id, @slide.id, 4, :cant_be_changed
    @documents_slide.document_id = 1
    assert_obj_saved @documents_slide
  end
  
  test 'uniqueness' do
    assert_invalid @documents_slide, :document_id, 2, 1, :taken
    assert_obj_saved @documents_slide
  end
  
  test 'allowed_slides' do
    DocumentsSlide.where(:slide_id => 3).delete_all
    Slide.where(:id => 2).update_all(:kind => 'title')
    assert_invalid @documents_slide, :slide_id, 2, 3, :doesnt_allow_documents
    Slide.where(:id => 2).update_all(:kind => 'image2')
    assert_invalid @documents_slide, :slide_id, 2, 3, :doesnt_allow_documents
    Slide.where(:id => 2).update_all(:kind => 'image3')
    assert_invalid @documents_slide, :slide_id, 2, 3, :doesnt_allow_documents
    Slide.where(:id => 2).update_all(:kind => 'image4')
    assert_invalid @documents_slide, :slide_id, 2, 3, :doesnt_allow_documents
    Slide.where(:id => 2).update_all(:kind => 'video2')
    assert_invalid @documents_slide, :slide_id, 2, 3, :doesnt_allow_documents
    Slide.where(:id => 2).update_all(:kind => 'cover')
    assert_invalid @documents_slide, :slide_id, 2, 3, :doesnt_allow_documents
    @documents_slide.slide_id = 2
    Slide.where(:id => 2).update_all(:kind => 'image1')
    assert @documents_slide.valid?
    Slide.where(:id => 2).update_all(:kind => 'video1')
    assert @documents_slide.valid?
    Slide.where(:id => 2).update_all(:kind => 'audio')
    assert @documents_slide.valid?
    Slide.where(:id => 2).update_all(:kind => 'text')
    assert @documents_slide.valid?
  end
  
end
