class MailingListAddress < ActiveRecord::Base
  belongs_to :group, class_name: MailingListGroup
  attr_accessible :email, :heading

  def self.get_emails(user_id, term)
    joins(:group).where(mailing_list_groups: { user_id: user_id }).where('mailing_list_addresses.email ILIKE ? OR mailing_list_addresses.heading ILIKE ?',"%#{term}%","%#{term}%").select('mailing_list_addresses.email AS value')
  end
end
