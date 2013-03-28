# == Description
#
# ActiveRecord class that corresponds to the table +mailing_list_addresses+.
#
# == Fields
# 
# * *group_id*: the reference to MailingListGroup
# * *heading*: the name that the user associates to the e-mail address
# * *email*: eht email address
#
# == Associations
#
# * *group*: reference to the MailingListGroup to which the address belongs (*belongs_to*)
#
# == Validations
#
# * *presence* for +email+ and +heading+
# * *presence* with numericality and existence of associated record for +group_id+
# * *length* of +heading+, maximum is 255
# * *correctness* of +email+ as an e-mail address
#
# == Callbacks
#
# None
#
# == Database callbacks
#
# None
#
class MailingListAddress < ActiveRecord::Base
  
  attr_accessible :email, :heading
  
  belongs_to :group, class_name: MailingListGroup
  
  validates_presence_of :email, :heading, :group_id
  validates_numericality_of :group_id, :greater_than => 0, :only_integer => true
  validates_length_of :heading, :maximum => 255
  validates :email, email_format: { :message => I18n.t(:invalid_email_address, :scope => [:activerecord, :errors, :messages], :default => 'does not appear to be valid') }
  validate :validate_associations
  
  before_validation :init_validation
  
  private
  
  def init_validation
    @group = Valid.get_association(self, :group_id, MailingListGroup)
    @mailing_list_address = Valid.get_association self, :id
  end
  
  def validate_associations
    errors.add(:group_id, :doesnt_exist) if @group.nil?
  end
  
end
