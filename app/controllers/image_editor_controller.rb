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
      o_image = Image.find(params[:image_id])
      
      if !params[:cropped_image].blank?
        img = MiniMagick::Image.open("#{Rails.root}#{params[:cropped_image]}")
        original_width = img[:width]
        original_height = img[:height]
      else
        img = MiniMagick::Image.open(o_image.media.path)
        original_width = o_image.media.width
        original_height = o_image.media.height
      end
      
      woh = width_or_height(original_width,original_height)
      
      x1= ratio_value(woh[1],params[:x1],woh[0])
      y1= ratio_value(woh[1],params[:y1],woh[0])
      x2= ratio_value(woh[1],params[:x2],woh[0])
      y2= ratio_value(woh[1],params[:y2],woh[0])
      
      w = x2.to_i - x1.to_i
      h = y2.to_i - y1.to_i
      
      crop_params = "#{w}x#{h}+#{x1}+#{y1}"
      img.crop(crop_params)
      image_dir = "/public/media_elements/images/#{params[:image_id]}"
      img.write("#{Rails.root}#{image_dir}/temp_crop.jpg")
      @image_url = "#{image_dir}/temp_crop.jpg"
      
      @image_id = params[:image_id]
      @crop = true
    else
      @crop = false
    end
  end
  
  def save
    o_image = Image.find(params[:image_id])
    if !params[:cropped_image].blank?
      img = MiniMagick::Image.open("#{Rails.root}#{params[:cropped_image]}")
      original_width = img[:width]
      original_height = img[:height]
    else
      img = MiniMagick::Image.open(o_image.media.path)
      original_width = o_image.media.width
      original_height = o_image.media.height
    end
    
    woh = width_or_height(original_width,original_height)
        
    textCount = (params.length - 5) / 4

    (0..textCount-1).each do |t_num|

      img.combine_options do |c|
        color_value = params["color_#{t_num}"]
        color_hex = CONFIG["colors"]["#{color_value.gsub('color_','')}"]["code"]

        c.fill "#{color_hex}"
        c.stroke "none"
        #c.encoding = "Unicode"
        c.font "#{Rails.root}/vendor/fonts/wt014.ttf"
        size_value = params["font_#{t_num}"]
        width_val = woh[1]
        original_val = woh[0]
        c.pointsize "#{ratio_value(width_val,(size_value.to_f*72/96), original_val)}"
        c.gravity 'NorthWest'
        
        coords_value = params["coords_#{t_num}"].split(",")
        c0 = ratio_value(width_val,coords_value[0], original_val)
        c1 = ratio_value(width_val,coords_value[1], original_val)
        text_value = params["text_#{t_num}"]
        
        c.draw "text #{c0},#{c1} \'#{text_value}\'"
        
      end
    end
    
    if !params[:x1].blank?
      x1= ratio_value(woh[1],params[:x1],woh[0])
      y1= ratio_value(woh[1],params[:y1],woh[0])
      x2= ratio_value(woh[1],params[:x2],woh[0])
      y2= ratio_value(woh[1],params[:y2],woh[0])
    
      w = x2.to_i - x1.to_i
      h = y2.to_i - y1.to_i
    
      crop_params = "#{w}x#{h}+#{x1}+#{y1}"
      img.crop(crop_params)
    end
    
    image_dir = "/public/media_elements/images/#{params[:image_id]}"
    img.write("#{Rails.root}#{image_dir}/final_crop.jpg")
    
  end
  
  private
  
  def width_or_height(original_w,original_h)
    to_ratio = 660/495
    origin_ratio = original_w.to_f/original_h.to_f
    if origin_ratio > to_ratio
      return [original_w,660]
    else
      return [original_h,495]
    end
  end
  
  
  def ratio_value(scale_to_px, value, original)
    ratio = original.to_f / scale_to_px.to_f if (original.to_i > scale_to_px.to_i )
    if ratio
      return value.to_f * ratio.to_f
    else
      return value
    end
  end
  
end
