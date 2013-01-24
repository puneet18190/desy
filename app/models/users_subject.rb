class UsersSubject < ActiveRecord::Base
  
  attr_accessible :user, :subject, :user_id, :subject_id
  
  belongs_to :user
  belongs_to :subject
  
  validates_presence_of :user, :subject
  validates_uniqueness_of :subject_id, :scope => :user_id
end
