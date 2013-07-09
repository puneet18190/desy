class Document < ActiveRecord::Base
  
  # Maximum length of the title
  MAX_TITLE_LENGTH = (I18n.t('language_parameters.document.length_title') > 255 ? 255 : I18n.t('language_parameters.document.length_title'))
  
  attr_accessible :title, :description
  
  belongs_to :user
  
  validates_presence_of :user_id, :title, :description
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_length_of :title, :maximum => MAX_TITLE_LENGTH
  validates_length_of :description, :maximum => I18n.t('language_parameters.document.length_description')
  validate :validate_associations
  
  before_validation :init_validation
  
  private
  
  def validate_associations
    errors.add(:user_id, :doesnt_exist) if @user.nil?
  end
  
  def init_validation
    @document = Valid.get_association self, :id
    @user = Valid.get_association self, :user_id
  end
  
end
