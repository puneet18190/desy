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
  
end
