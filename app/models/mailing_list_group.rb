# == Description
#
# ActiveRecord class that corresponds to the table +mailing_list_groups+.
#
# == Fields
# 
# * *user_id*: the reference to the User owner of the group
# * *name*: the name of the group
#
# == Associations
#
# * *user*: reference to the User owner of the group (*belongs_to*)
# * *addresses*: reference to the associated addresses (see MailingListAddress) (*has_many*)
#
# == Validations
#
# * *presence* for +name+
# * *presence* with numericality and existence of associated record for +user_id+
# * *length* of +name+, maximum is 255
# * *uniqueness* for +name+
#
# == Callbacks
#
# None
#
# == Database callbacks
#
# TODO qui ne manca una
#
class MailingListGroup < ActiveRecord::Base
  
  attr_accessible :name
  
  belongs_to :user
  has_many :addresses, :class_name => MailingListAddress, :foreign_key => 'group_id', :dependent => :destroy
  
  validates_presence_of :name, :user_id
  validates_length_of :name, :maximum => 255
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_uniqueness_of :name
  validate :validate_associations
  
  before_validation :init_validation
  
  private
  
  def init_validation
    @user = Valid.get_association(self, :user_id)
    @mailing_list_group = Valid.get_association self, :id
  end
  
  def validate_associations
    errors.add(:user_id, :doesnt_exist) if @user.nil?
  end
  
end
