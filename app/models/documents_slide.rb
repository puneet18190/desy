# == Description
#
# ActiveRecord class that corresponds to the table +documents_slides+.
#
# == Fields
#
# * *document_id*: id of the document
# * *slide_id*: id of the slide
#
# == Associations
#
# * *document*: reference to the Document (*belongs_to*)
# * *slide*: reference to the Slide (*belongs_to*)
#
# == Validations
#
# * *presence* with numericality and existence of associated record for +document_id+ and +slide_id+
# * *modifications* *not* *available* for the +document_id+ and +slide_id+
#
# == Callbacks
#
# None
#
# == Database callbacks
#
# None
#
class DocumentsSlide < ActiveRecord::Base
  
  belongs_to :document
  belongs_to :slide
  
  validates_presence_of :document_id, :slide_id
  validates_numericality_of :document_id, :slide_id, :only_integer => true, :greater_than => 0
  validates_uniqueness_of :document_id, :scope => :slide_id
  validate :validate_associations, :validate_impossible_changes
  
  before_validation :init_validation
  
  private
  
  # Validates the presence of all the associated objects
  def validate_associations
    errors.add(:document_id, :doesnt_exist) if @document.nil?
    errors.add(:slide_id, :doesnt_exist) if @slide.nil?
  end
  
  # Initializes validation objects (see Valid.get_association)
  def init_validation
    @documents_slide = Valid.get_association self, :id
    @document = Valid.get_association self, :document_id
    @slide = Valid.get_association self, :slide_id
  end
  
  # Validates that if the document is not new record the field +user_id+ cannot be changed
  def validate_impossible_changes
    if @documents_slide
      errors.add(:document_id, :cant_be_changed) if @documents_slide.document_id != self.document_id
      errors.add(:slide_id, :cant_be_changed) if @documents_slide.slide_id != self.slide_id
    end
  end
  
end