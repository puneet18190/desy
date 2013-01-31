class MailingListGroup < ActiveRecord::Base
  belongs_to :user
  has_many :addresses, :class_name => MailingListAddress, :dependent => :destroy
  attr_accessible :name
end