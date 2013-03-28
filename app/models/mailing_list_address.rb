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
# # * *group*: reference to the MailingListGroup to which the address belongs (*belongs_to*).
#
# == Validations
#
# * *presence* for +email+ and +heading+
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
  
  validates_presence_of :email, :heading
  validates :email, email_format: { :message => I18n.t(:invalid_email_address, :scope => [:activerecord, :errors, :messages], :default => 'does not appear to be valid') }
  
end
