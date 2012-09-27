class SchoolLevel < ActiveRecord::Base
  
  attr_accessible :description
  
  has_many :lessons
  has_many :users
  
  validates_presence_of :description
  validates_length_of :description, :maximum => 255
  
end
