class User < ActiveRecord::Base
  
  has_many :bookmarks
  has_many :notifications
  has_many :likes
  has_many :lessons
  has_many :media_elements
  has_many :reports
  has_many :users_subjects
  has_many :virtual_classroom_lessons
  belongs_to :school_level
  belongs_to :location
  
  validates_presence_of :email, :name, :surname, :school_level_id, :school, :location_id
  validates_numericality_of :school_level_id, :location_id, :only_integer => true, :greater_than => 0
  validates_uniqueness_of :email
  validates_length_of :name, :surname, :email, :school, :maximum => 255
  
  validate :validate_associations, :validate_email
  
  def validate_associations
    errors[:location_id] << "doesn't exist" if !Location.exists?(self.location_id)
    errors[:school_level_id] << "doesn't exist" if !SchoolLevel.exists?(self.school_level_id)
  end
  
  def validate_email
    flag = false
    x = self.email.split('@')
    if x.length == 2
      x = x[1].split('.')
      if x.length > 1
        flag = true if x.last.length != 2
      else
        flag = true
      end
    else
      flag = true
    end
    errors[:email] << 'not in the correct format' if flag
  end
  
end
