class Slide < ActiveRecord::Base
  
  has_many :media_elements_slides
  belongs_to :lesson
  
end
