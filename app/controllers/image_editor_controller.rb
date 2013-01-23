class ImageEditorController < ApplicationController
  
  before_filter :initialize_image_with_owner_or_public, :only => [:edit, :crop, :save, :add_text, :undo]
  before_filter :initialize_image_with_owner_and_private, :only => :overwrite
  layout 'media_element_editor'
  
  def edit
    if !@ok
      redirect_to dashboard_path
      return
    end
    @image.leave_edit_mode current_user.id
    @image.enter_edit_mode current_user.id
  end
  
  def add_text
    if @ok
      @image.enter_edit_mode current_user.id
      if @image.add_text extract_textareas_params(params)
        @new_url = @image.editing_url
      else
        @new_url = ''
      end
    else
      @new_url = ''
    end
  end
  
  def undo
    if @ok
      @image.enter_edit_mode current_user.id
      if @image.undo
        @new_url = @image.editing_url
        @new_img = MiniMagick::Image.open @image.current_editing_image
      else
        @new_url = ''
      end
    else
      @new_url = ''
    end
  end
  
  def crop
    if @ok && !params[:x1].blank?
      @image.enter_edit_mode current_user.id
      if @image.crop(params[:x1], params[:y1], params[:x2], params[:y2])
        @new_url = @image.editing_url
        @new_img = MiniMagick::Image.open @image.current_editing_image
      else
        @new_url = ''
      end
    else
      @new_url = ''
    end
  end
  
  def save
    if @ok
      @image.enter_edit_mode current_user.id
      @redirect = false
      if parameters.nil?
        current_user.empty_video_editor_cache
        @redirect = true
        return
      end
      new_image = Image.new
      new_image.title = params[:new_title_placeholder] != '0' ? '' : params[:new_title]
      new_image.description = params[:new_description_placeholder] != '0' ? '' : params[:new_description]
      new_image.tags = params[:new_tags_placeholder] != '0' ? '' : params[:new_tags]
      new_image.user_id = current_user.id
      new_image.media = @image.current_editing_image
      if new_image.save
        redirect_to '/dashboard'
        return
      else
        @error_ids = 'new'
        @errors = convert_item_error_messages(new_image.errors.messages)
        @error_fields = new_image.errors.messages.keys
      end
    else
      @redirect = true
    end
  end
  
  def overwrite
    if @ok
      @redirect = false
      @image.enter_edit_mode current_user.id
      @image.title = params[:update_title]
      @image.description = params[:update_description]
      @image.tags = params[:update_tags]
      if @image.save
        redirect_to '/dashboard'
        return
      else
        @error_ids = 'update'
        @errors = convert_item_error_messages(@image.errors.messages)
        @error_fields = @image.errors.messages.keys
      end
    else
      @redirect = true
    end
    render 'save'
  end
  
  private
  
  def extract_textareas_params(params)
    resp = {}
    fonts = {'small_font' => 15, 'medium_font' => 25, 'big_font' => 35}
    params.each do |k, v|
      if !(k =~ /_/).nil?
        index = k.split('_').last.to_i
        p = k.gsub("_#{index}", '')
        if ['color', 'font', 'coords', 'text'].include?(p)
          if resp.has_key? index
            resp[index][:"#{p}"] = v
          else
            resp[index] = {:"#{p}" => v}
          end
        end
      end
    end
    final_resp = []
    resp.each do |k, v|
      final_resp << {
        :color => SETTINGS['colors'][v[:color].gsub('color_', '')]['code'],
        :font_size => fonts[v[:font]].to_f,
        :coord_x => v[:coords].split(',').first.to_f,
        :coord_y => v[:coords].split(',').last.to_f,
        :text => v[:text]
      }
    end
    final_resp
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
