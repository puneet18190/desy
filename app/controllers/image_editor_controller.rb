class ImageEditorController < ApplicationController
  
  before_filter :initialize_image_with_owner_or_public, :only => [:edit, :crop, :save]
  before_filter :initialize_image_with_owner_and_private, :only => :overwrite
  layout 'media_element_editor'
  
  def edit
    if !@ok
      redirect_to dashboard_index_path
      return
    end
  end
  
  def crop
    if @ok
      if !params[:x1].blank?
        if !params[:cropped_image].blank?
          img = MiniMagick::Image.open("#{Rails.root}#{params[:cropped_image]}")
          original_width = img[:width]
          original_height = img[:height]
        else
          img = MiniMagick::Image.open(@image.media.path)
          original_width = @image.media.width
          original_height = @image.media.height
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
    else
      # mettere 'X' rossa
    end
  end
  
  def save
    if @ok
      if !params[:cropped_image].blank?
        img = MiniMagick::Image.open("#{Rails.root}#{params[:cropped_image]}")
        original_width = img[:width]
        original_height = img[:height]
      else
        img = MiniMagick::Image.open(@image.media.path)
        original_width = @image.media.width
        original_height = @image.media.height
      end
      woh = width_or_height(original_width,original_height)
      textCount = 0
      params.each do |p,val|
        if p.starts_with?('text')
          textCount += 1
        end
      end
      logger.info "\n\n\n\n\n tCount: #{textCount} \n\n\n\n"
      if textCount > 0
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
            coords_value = params["coords_#{t_num}"].to_s.split(",")
            c0 = ratio_value(width_val,coords_value[0], original_val)
            c1 = ratio_value(width_val,coords_value[1], original_val)
            text_value = params["text_#{t_num}"]
            c.draw "text #{c0},#{c1} \'#{text_value}\'"
          end
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
      #TODO update replacing write temp image
      img.write("#{Rails.root}#{image_dir}/final_crop.jpg")
      new_image = Image.new { |me| me.user = @current_user }

      new_image.title = params[:new_title]
      new_image.description = params[:new_description]
      new_image.tags = params[:new_tags]
      
      logger.info "\n\n\n\n\n\n valid: #{new_image.valid?} \n\n\n"
      
      if !new_image.valid?
        msg = new_image.errors.messages
        msg.delete(:media)
        logger.info "\n\n\n\n\n\n message: #{msg} \n\n\n"
      end
      
      if msg && msg.empty?
        new_image.media = File.open("#{Rails.root}#{image_dir}/final_crop.jpg")
        new_image.save
      else
        @errors = msg
        logger.info "\n\n\n\n\n\n errors: #{@errors} \n\n\n"
      end
      
      # manca redirect_to my_media_elements_path
      
    else
      redirect_to '/dashboard'
    end
  end
  
  def overwrite
    if @ok
      if !params[:cropped_image].blank?
        img = MiniMagick::Image.open("#{Rails.root}#{params[:cropped_image]}")
        original_width = img[:width]
        original_height = img[:height]
      else
        img = MiniMagick::Image.open(@image.media.path)
        original_width = @image.media.width
        original_height = @image.media.height
      end
      woh = width_or_height(original_width,original_height)
      textCount = 0
      params.each do |p,val|
        if p.starts_with?('text')
          textCount += 1
        end
      end
      logger.info "\n\n\n\n\n tCount: #{textCount} \n\n\n\n"
      if textCount > 0
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
            coords_value = params["coords_#{t_num}"].to_s.split(",")
            c0 = ratio_value(width_val,coords_value[0], original_val)
            c1 = ratio_value(width_val,coords_value[1], original_val)
            text_value = params["text_#{t_num}"]
            c.draw "text #{c0},#{c1} \'#{text_value}\'"
          end
        end
      end
      logger.info "\n\n\n\n\n tCount after: #{textCount} \n\n\n\n"
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
      final_image_url = img.write("#{Rails.root}#{image_dir}/final_crop.jpg")
      @image

      @image.title = params[:new_title]
      @image.description = params[:new_description]
      @image.tags = params[:new_tags]
            
      
      
      if @image.valid?
        @image.media = File.open("#{Rails.root}#{image_dir}/final_crop.jpg")
        @image.save
      else
        @errors = @image.errors.messages
      end
      
      # manca redirect_to my_media_elements_path
      
    else
      redirect_to '/dashboard'
    end
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
  
  def initialize_image_with_owner_or_public
    @image_id = correct_integer?(params[:image_id]) ? params[:image_id].to_i : 0
    @image = Image.find_by_id @image_id
    update_ok(!@image.nil? && (@image.is_public || @current_user.id == @image.user_id))
  end
  
  def initialize_image_with_owner_and_private
    @image_id = correct_integer?(params[:image_id]) ? params[:image_id].to_i : 0
    @image = Image.find_by_id @image_id
    update_ok(!@image.nil? && !@image.is_public && @current_user.id == @image.user_id)
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
