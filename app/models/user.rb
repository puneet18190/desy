class User < ActiveRecord::Base
  
  attr_accessible :name, :surname, :school_level_id, :school, :location_id
  
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
  validate :validate_associations, :validate_email, :validate_email_not_changed
  
  before_validation :init_validation
  
  private
  
  def init_validation
    @user = self.new_record? ? nil : User.where(:id => self.id).first
  end
  
  def validate_associations
    errors[:location_id] << "doesn't exist" if !Location.exists?(self.location_id)
    errors[:school_level_id] << "doesn't exist" if !SchoolLevel.exists?(self.school_level_id)
  end
  
  def validate_email
    return if self.email.blank?
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
    errors[:email] << 'is not in the correct format' if flag
  end
  
  def validate_email_not_changed
    return if @user.nil?
    errors[:email] << "can't change after having been initialized" if @user.email != self.email
  end
  
end
