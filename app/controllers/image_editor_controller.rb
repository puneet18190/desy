class ImageEditorController < ApplicationController
  
  layout 'media_element_editor'
  
  def index
    
  end
  
  #process image [with text]
  def create
    original_image = params[:image] 
    
    
    img = MiniMagick::Image.open(original_image[:url])
    
    (1..10).each do |i|
      img.combine_options do |c|
        c.fill  params["text_color_#{i}"]
        #c.stroke 'black'
        #c.font 'Candice'
        #pointsize font to scale
        c.pointsize params["text_size_#{i}"]
        #c.gravity 'center'
        #text_position must be X,Y to scale
        c.draw "text "+params["text_position_#{i}"] + params["text_#{i}"].to_s
      end
    end
    
    img.write("path_to_updated_file.jpg")
    
  end
  
  def crop
    
  end
  
end
