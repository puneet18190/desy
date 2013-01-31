class MailingListAddress < ActiveRecord::Base
  belongs_to :mailing_list_group
  attr_accessible :email, :heading
end
