class Subject < ActiveRecord::Base
  
  attr_accessible :description
  
  has_many :lessons
  has_many :users_subjects
  
  validates_presence_of :description
  validates_length_of :description, :maximum => 255

  def to_s
    description.to_s
  end
  
end
