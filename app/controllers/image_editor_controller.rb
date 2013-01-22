require 'shellwords'
require 'media/image/editing/add_text_to_image'
require 'media/image/editing/crop'

class ImageEditorController < ApplicationController
  
  before_filter :initialize_image_with_owner_or_public, :only => [:edit, :crop, :save]
  before_filter :initialize_image_with_owner_and_private, :only => :overwrite
  layout 'media_element_editor'
  
  def edit
    if !@ok
      redirect_to dashboard_path
      return
    end
    current_user.empty_image_editor_cache(@image_id)
  end
  
  def crop
    if @ok && !params[:x1].blank?
      @crop_url = @image.crop params[:x1], params[:y1], params[:x2], params[:y2], current_user.id
    else
      @crop_url = ''
    end
  end
  
  def save
    if @ok
      if !params[:x1].blank?
        @image.crop params[:x1], params[:y1], params[:x2], params[:y2], current_user.id
      end
      image_url = @image.process_textareas extract_textareas_params(params)
      
      
      
      new_image = Image.new
      new_image.user_id = current_user.id
      new_image.title = params[:new_title]
      new_image.description = params[:new_description]
      new_image.tags = params[:new_tags]
      new_image.valid?
      msg = new_image.errors.messages
      msg.delete(:media)
      if msg.empty?
          

          new_image.media = File.open(new_file_path)
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
        editing_folder = File.join(@image.media.folder, "editing","user_#{current_user.id}")
        image_path = File.join(editing_folder,params[:cropped_image])
        img = MiniMagick::Image.open(image_path)
        original_width = img[:width]
        original_height = img[:height]
      else
        image_path = @image.url
        img = MiniMagick::Image.open(image_path)
        original_width = @image.media.width
        original_height = @image.media.height
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

      @image.title = params[:update_title]
      @image.description = params[:update_description]
      @image.tags = params[:update_tags]
            
      
      
      if @image.valid?
        in_tmpdir do |tmpdir|
          new_filename = "#{params[:new_title].gsub(/[^0-9A-Za-z]/, '')}-edit-#{Time.now.strftime('%Y%m%d-%H%M%S')}.jpg"
          img.write("#{tmpdir}/#{new_filename}")
          woh = width_or_height(original_width,original_height)
          process_textareas extract_textareas(params)
          @image.media = File.open("#{tmpdir}/#{new_filename}")
          @image.save
          remove_crop_path(@image)
        end
      else
        @errors = @image.errors.messages
        logger.info "\n\n\n\n\n #{@errors} \n\n\n\n"
      end
      
      # manca redirect_to my_media_elements_path
      
    else
      redirect_to '/dashboard'
    end
  end
  
  private
  
  def extract_textareas_params(params)
    text_count = 0
    resp = []
    params.each do |p,val|
      if p.starts_with?('text')
        text_count += 1
      end
    end
    if text_count > 0
      (0..text_count-1).each do |t_num|
        resp << {
          :color => SETTINGS['colors'][params["color_#{t_num}"].gsub('color_', '')]['code'],
          :font_size => params["font_#{t_num}"].to_f,
          :coord_x => params["coords_#{t_num}"].split(',').first.to_f,
          :coord_y => params["coords_#{t_num}"].split(',').last.to_f,
          :text => params["text_#{t_num}"]
        }
      end
    end
    resp
  end
  
  def initialize_image_with_owner_or_public
    @image_id = correct_integer?(params[:image_id]) ? params[:image_id].to_i : 0
    @image = Image.find_by_id @image_id
    update_ok(!@image.nil? && (@image.is_public || current_user.id == @image.user_id))
  end
  
  def initialize_image_with_owner_and_private
    @image_id = correct_integer?(params[:image_id]) ? params[:image_id].to_i : 0
    @image = Image.find_by_id @image_id
    update_ok(!@image.nil? && !@image.is_public && current_user.id == @image.user_id)
  end
  
end
