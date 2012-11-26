class UsersSubject < ActiveRecord::Base
  
  attr_accessible :user_id, :subject_id
  
  belongs_to :user
  belongs_to :subject
  
  validates_presence_of :user_id, :subject_id
  validates_numericality_of :user_id, :subject_id, :only_integer => true, :greater_than => 0
  validates_uniqueness_of :subject_id, :scope => :user_id
  validate :validate_associations
  
  before_validation :init_validation
  
  private
  
  def init_validation
    @users_subject = Valid.get_association self, :id
    @user = Valid.get_association self, :user_id
    @subject = Valid.get_association self, :subject_id
  end
  
  def validate_associations
    errors[:user_id] << "doesn't exist" if @user.nil?
    errors[:subject_id] << "doesn't exist" if @subject.nil?
  end
  
end
