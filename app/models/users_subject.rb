class UsersSubject < ActiveRecord::Base
  
  attr_accessible :user, :subject, :user_id, :subject_id
  
  belongs_to :user
  belongs_to :subject
  
  validates_presence_of :user, if: proc{ |r| r.user_id.blank? }
  validates_presence_of :subject, if: proc{ |r| r.subject_id.blank? }
  validates_presence_of :user_id, if: proc{ |r| r.user.blank? }
  validates_presence_of :subject_id, if: proc{ |r| r.subject.blank? }
  validates_uniqueness_of :subject_id, :scope => :user_id
end
