class Slide < ActiveRecord::Base
  
  attr_accessible :position, :title
  
  has_many :media_elements_slides
  belongs_to :lesson
  
end
