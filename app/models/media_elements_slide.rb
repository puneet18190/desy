class MediaElementsSlide < ActiveRecord::Base
  
  belongs_to :media_element
  belongs_to :slide
  
end
