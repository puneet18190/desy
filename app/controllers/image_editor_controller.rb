class ImageEditorController < ApplicationController
  
  layout 'media_element_editor'
  
  def index
    @image = Image.find(params[:image_id])
  end
  
  #process image [with text]
  def create
    original_image = Image.find(params[:image_id])
    
    
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
    original_image = Image.find(params[:image_id])
    img = MiniMagick::Image.open(original_image.media.path)
    
    x1= params[:x1]
    y1= params[:y1]
    w= params[:x2].to_i - x1.to_i
    h= params[:y2].to_i - y1.to_i
    #100% image TODO scale dimensions
    crop_params = "#{w}x#{h}+#{x1}+#{y1}"
    img.crop(crop_params)
    image_dir = "/media_elements/images/#{params[:image_id]}"
    img.write("#{image_dir}/temp_crop.jpg")
    @image_url = "#{image_dir}/temp_crop.jpg"    
  end
  
end
