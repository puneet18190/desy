require 'shellwords'
require 'media/image/editing/add_text_to_image'
require 'media/image/editing/crop'

class ImageEditorController < ApplicationController

  before_filter :initialize_image_with_owner_or_public, :only => [:edit, :crop, :save]
  before_filter :initialize_image_with_owner_and_private, :only => :overwrite
  layout 'media_element_editor'
  
  def edit
    if !@ok
      # editing_folder = File.join(@image.media.absolute_folder, "editing","user_#{@current_user.id}") exists
      # File.exists?(editing_folder)
      #TODO ADD WARNING MESSAGE with 'image already in editing'
      redirect_to dashboard_index_path
      return
    end
  end
  
  def crop
    if @ok
      if !params[:x1].blank?
        if !params[:cropped_image].blank?          
          editing_folder = File.join(@image.media.absolute_folder, "editing","user_#{@current_user.id}")
          img = MiniMagick::Image.open(File.join(editing_folder,params[:cropped_image]))
          original_width = img[:width]
          original_height = img[:height]
        else
          img = MiniMagick::Image.open(@image.media.path)
          original_width = @image.media.width
          original_height = @image.media.height
          editing_folder = File.join(@image.media.absolute_folder, "editing","user_#{@current_user.id}")

          #Make dir of first crop
          FileUtils.mkdir_p(editing_folder) unless Dir.exists? editing_folder
        end
        
        woh = width_or_height(original_width,original_height)
        x1= ratio_value(woh[1],params[:x1],woh[0])
        y1= ratio_value(woh[1],params[:y1],woh[0])
        x2= ratio_value(woh[1],params[:x2],woh[0])
        y2= ratio_value(woh[1],params[:y2],woh[0])
        
        #BRING OUT IMAGE WRITE FROM CROP
        @custom_filename = Media::Image::Editing::Crop.new(img, editing_folder, x1, y1, x2, y2).run
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
        editing_folder = File.join(@image.media.absolute_folder, "editing","user_#{@current_user.id}")
        img = MiniMagick::Image.open(File.join(editing_folder,params[:cropped_image]))
        original_height = img[:height]
        original_width = img[:width]
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
      
      if textCount > 0
        (0..textCount-1).each do |t_num|
          
          color_value = params["color_#{t_num}"]
          color_hex = CONFIG["colors"]["#{color_value.gsub('color_','')}"]["code"]
          size_value = params["font_#{t_num}"].to_f
          width_val = woh[1]
          original_val = woh[0]
          font_size = "#{ratio_value(width_val,(size_value), original_val)}"
          coords_value = params["coords_#{t_num}"].to_s.split(",")
          coordX = ratio_value(width_val,coords_value[0], original_val)
          coordY = ratio_value(width_val,coords_value[1], original_val)
          text_value = params["text_#{t_num}"]
          
          tmp_file = Tempfile.new('textarea')
          begin
            tmp_file << text_value
            Media::Image::Editing::AddTextToImage.new(img, color_hex, font_size, coordX, coordY, text_value).run
          ensure
            tmp_file.close
            tmp_file.unlink
          end
          
          #img.combine_options do |c|
          #  color_value = params["color_#{t_num}"]
          #  color_hex = CONFIG["colors"]["#{color_value.gsub('color_','')}"]["code"]
          #  c.fill "#{color_hex}"
          #  c.stroke "none"
          #  #c.encoding = "Unicode"
          #  c.font "#{Rails.root}/vendor/fonts/DroidSansFallback.ttf"
          #  size_value = params["font_#{t_num}"].to_f
          #  width_val = woh[1]
          #  original_val = woh[0]
          #  c.pointsize "#{ratio_value(width_val,(size_value), original_val)}"
          #  c.gravity 'NorthWest'
          #  coords_value = params["coords_#{t_num}"].to_s.split(",")
          #  c0 = ratio_value(width_val,coords_value[0], original_val)
          #  c1 = ratio_value(width_val,coords_value[1], original_val)
          #  text_value = params["text_#{t_num}"]
          #
          #  c.draw "text #{c0},#{c1} '#{text_value}'"
          #end
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
      
      #TODO update replacing write temp image
      #image_dir = "/public/media_elements/images/#{params[:image_id]}"
      #img.write("#{Rails.root}#{image_dir}/final_crop.jpg")
      
      
      new_image = Image.new { |me| me.user = @current_user }

      new_image.title = params[:new_title]
      new_image.description = params[:new_description]
      new_image.tags = params[:new_tags]
      
      new_image.valid?
        msg = new_image.errors.messages
        msg.delete(:media)
      
      if msg.empty?
        in_tmpdir do |tmpdir|
          new_filename = "#{params[:new_title].gsub(/[^0-9A-Za-z]/, '')}-edit-#{Time.now.strftime('%Y%m%d-%H%M%S')}.jpg"
          img.write("#{tmpdir}/#{new_filename}")
          new_image.media = File.open("#{tmpdir}/#{new_filename}")
          new_image.save
          remove_crop_path(@image)
        end
      else
        @errors = msg
      end
      
      # manca redirect_to my_media_elements_path
      
    else
      redirect_to '/dashboard'
    end
  end
  
  def overwrite
    if @ok
      if !params[:cropped_image].blank?
        editing_folder = File.join(@image.media.absolute_folder, "editing","user_#{@current_user.id}")
        img = MiniMagick::Image.open(File.join(editing_folder,params[:cropped_image]))
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

      if textCount > 0
        (0..textCount-1).each do |t_num|
          img.combine_options do |c|
            color_value = params["color_#{t_num}"]
            color_hex = CONFIG["colors"]["#{color_value.gsub('color_','')}"]["code"]
            c.fill "#{color_hex}"
            c.stroke "none"
            c.font "#{Rails.root}/vendor/fonts/DroidSansFallback.ttf"
            size_value = params["font_#{t_num}"].to_f # should add * 0.75 to compensate px to pt
            width_val = woh[1]
            original_val = woh[0]
            c.pointsize "#{ratio_value(width_val,(size_value), original_val)}"
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
      
      #image_dir = "/public/media_elements/images/#{params[:image_id]}"
      #img.write("#{Rails.root}#{image_dir}/final_crop.jpg")

      @image.title = params[:update_title]
      @image.description = params[:update_description]
      @image.tags = params[:update_tags]
            
      
      
      if @image.valid?
        in_tmpdir do |tmpdir|
          new_filename = "#{params[:new_title].gsub(/[^0-9A-Za-z]/, '')}-edit-#{Time.now.strftime('%Y%m%d-%H%M%S')}.jpg"
          img.write("#{tmpdir}/#{new_filename}")
          @image.media = File.open("#{tmpdir}/#{new_filename}")
          @image.save
          remove_crop_path(@image)
        end
      else
        @errors = @image.errors.messages
      end
      
      # manca redirect_to my_media_elements_path
      
    else
      redirect_to '/dashboard'
    end
  end
  
  private
  
  def remove_crop_path(image)
    editing_folder = File.join(image.media.absolute_folder, "editing","user_#{@current_user.id}")
    FileUtils.rm_rf(editing_folder) if File.exists?(editing_folder)
  end
  
  def in_tmpdir
    path = File.expand_path "#{Dir.tmpdir}/#{Time.now.to_i}#{rand(1000)}/"
    FileUtils.mkdir_p path
    yield path
  ensure
    FileUtils.rm_rf(path) if File.exists?(path)
  end
  
  def remove_tmp_crop(image_dir)
    #dir_contents = Dir.entries("#{image_dir}")
  end
  
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
