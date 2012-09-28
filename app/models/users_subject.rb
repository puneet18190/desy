class UsersSubject < ActiveRecord::Base
  
  attr_accessible :user_id, :subject_id
  
  belongs_to :user
  belongs_to :subject
  
  validates_presence_of :user_id, :subject_id
  validates_numericality_of :user_id, :subject_id, :only_integer => true, :greater_than => 0
  validates_uniqueness_of :subject_id, :scope => :user_id
  validate :validate_associations
  
  before_destroy :check_if_last
  
  private
  
  def validate_associations
    errors[:user_id] << "doesn't exist" if !User.exists?(self.user_id)
    errors[:subject_id] << "doesn't exist" if !Subject.exists?(self.subject_id)
  end
  
  def check_if_last
    @users_subject = self.new_record? ? nil : UsersSubject.where(:id => self.id).first
    return true if @users_subject.nil?
    return (UsersSubject.where(:user_id => @users_subject.user_id).length > 1)
  end
  
end
