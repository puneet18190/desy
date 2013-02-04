class MailingListGroup < ActiveRecord::Base
  belongs_to :user
  has_many :addresses, :class_name => MailingListAddress, :foreign_key => 'group_id', :dependent => :destroy
  attr_accessible :name
end