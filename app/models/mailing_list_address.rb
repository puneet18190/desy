class MailingListAddress < ActiveRecord::Base
  belongs_to :group, class_name: MailingListGroup
  attr_accessible :email, :heading

  def self.test(user_id)
    joins(:group).where(mailing_list_groups: { user_id: user_id }).select('mailing_list_addresses.heading, mailing_list_addresses.email')
  end
end
