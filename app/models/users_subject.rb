class UsersSubject < ActiveRecord::Base
  
  attr_accessible :user_id, :subject_id
  
  belongs_to :user
  belongs_to :subject
  
  validates_presence_of :user_id, :subject_id
  validates_numericality_of :user_id, :subject_id, :only_integer => true, :greater_than => 0
  validates_uniqueness_of :subject_id, :scope => :user_id
  validate :validate_associations
  
  private
  
  def validate_associations
    errors[:user_id] << "doesn't exist" if !User.exists?(self.user_id)
    errors[:subject_id] << "doesn't exist" if !Subject.exists?(self.subject_id)
  end
  
end
