# == Description
#
# ActiveRecord class that corresponds to the table +documents+.
#
# == Fields
#
# * *user_id*: id of the creator of the document
# * *title*: title
# * *description*: description
#
# == Associations
#
# * *user*: reference to the User who created the document (*belongs_to*)
# * *documents_slides*: instances of this Document contained in a slide (see DocumentsSlide) (*has_many*)
#
# == Validations
#
# * *presence* with numericality and existence of associated record for +user_id+
# * *presence* for +title+ and +description+
# * *length* of +title+ and +description+ (values configured in the I18n translation file; only for title, if the value is greater than 255 it's set to 255)
# * *modifications* *not* *available* for the +user_id+
#
# == Callbacks
#
# None
#
# == Database callbacks
#
# None
#
class Document < ActiveRecord::Base
  
  # Maximum length of the title
  MAX_TITLE_LENGTH = (I18n.t('language_parameters.document.length_title') > 255 ? 255 : I18n.t('language_parameters.document.length_title'))
  
  attr_accessible :title, :description
  
  belongs_to :user
  has_many :documents_slides
  
  validates_presence_of :user_id
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_length_of :title, :maximum => MAX_TITLE_LENGTH
  validates_length_of :description, :maximum => I18n.t('language_parameters.document.length_description')
  validate :validate_associations, :validate_impossible_changes
  
  before_validation :init_validation
  
  private
  
  # Validates the presence of all the associated objects
  def validate_associations
    errors.add(:user_id, :doesnt_exist) if @user.nil?
  end
  
  # Initializes validation objects (see Valid.get_association)
  def init_validation
    @document = Valid.get_association self, :id
    @user = Valid.get_association self, :user_id
  end
  
  # Validates that if the document is not new record the field +user_id+ cannot be changed
  def validate_impossible_changes
    if @document
      errors.add(:user_id, :cant_be_changed) if @document.user_id != self.user_id
    end
  end
  
end
