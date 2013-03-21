class MailingListGroup < ActiveRecord::Base
  
  belongs_to :user
  has_many :addresses, :class_name => MailingListAddress, :foreign_key => 'group_id', :dependent => :destroy
  attr_accessible :name
  
  validates_presence_of :name, :allow_blank => false
  validates_uniqueness_of :name
  
end
