class ImageEditorController < ApplicationController
  
  layout 'media_element_editor'
  
  def edit
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
    if !params[:x1].blank?
      #o_image = Image.find(params[:image_id])
      #img = MiniMagick::Image.open(o_image.media.path)
      #
      #x1= o_image.ratio_value(500,params[:x1])
      #y1= o_image.ratio_value(500,params[:y1])
      #x2= o_image.ratio_value(500,params[:x2])
      #y2= o_image.ratio_value(500,params[:y2])
      #w = x2.to_i - x1.to_i
      #h = y2.to_i - y1.to_i
      #
      ##100% image TODO scale dimensions
      #crop_params = "#{w}x#{h}+#{x1}+#{y1}"
      #img.crop(crop_params)
      #image_dir = "/public/media_elements/images/#{params[:image_id]}"
      #img.write("#{Rails.root}#{image_dir}/temp_crop.jpg")
      ##@image_url = "#{image_dir}/temp_crop.jpg"
      
      @image_id = params[:image_id]
      @crop = true
    else
      @crop = false
    end
  end
  
  def save
    o_image = Image.find(params[:image_id])
    
    img = MiniMagick::Image.open(o_image.media.path)
    
    #if image width > 660
    x1= o_image.ratio_value(459,params[:x1])
    y1= o_image.ratio_value(459,params[:y1])
    x2= o_image.ratio_value(459,params[:x2])
    y2= o_image.ratio_value(459,params[:y2])
    w = x2.to_i - x1.to_i
    h = y2.to_i - y1.to_i
    
    textCount = (params.length - 5) / 4

    (0..textCount-1).each do |t_num|

      img.combine_options do |c|
        color_value = params["color_#{t_num}"]
        color_hex = CONFIG["colors"]["#{color_value.gsub('color_','')}"]
        logger.info "\n\n\n\n\n #{color_value} --- #{color_value.gsub('color_','')} --- #{color_hex}\n\n\n\n"
        c.fill "#{color_hex}"
        c.stroke "none"
        c.font 'Arial'
        size_value = params["font_#{t_num}"]
        logger.info "\n\n\n size: #{size_value} --- #{o_image.ratio_value(459,size_value)} \n\n\n"
        c.pointsize "#{o_image.ratio_value(459,(size_value.to_f*72/96))}"
        c.gravity 'NorthWest'
        
        coords_value = params["coords_#{t_num}"].split(",")
        c0 = o_image.ratio_value(459,coords_value[0])
        c1 = o_image.ratio_value(459,coords_value[1])
        text_value = params["text_#{t_num}"]
        logger.info "\n\n\n\n\n #{c0},#{c1} --- #{text_value} \n\n\n\n"
        c.draw "text #{c0},#{c1} \'#{text_value}\'"
        
      end
    end
    
    crop_params = "#{w}x#{h}+#{x1}+#{y1}"
    img.crop(crop_params)
    
    image_dir = "/public/media_elements/images/#{params[:image_id]}"
    img.write("#{Rails.root}#{image_dir}/final_crop.jpg")
    
  end
  
end
