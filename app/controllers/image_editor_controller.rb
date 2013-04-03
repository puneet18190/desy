# == Description
#
# Actions used in the image editor
#
# == Models used
#
# * Image
#
class ImageEditorController < ApplicationController
  
  before_filter :initialize_image_with_owner_or_public, :only => [:edit, :crop, :save, :add_text, :undo]
  before_filter :initialize_image_with_owner_and_private, :only => :overwrite
  layout 'media_element_editor'
  
  # === Description
  #
  # Opens the image editor with a selected image
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ImageEditorController#initialize_image_with_owner_or_public
  #
  def edit
    if !@ok
      redirect_to dashboard_path
      return
    end
    @back = params[:back] if params[:back].present?
    @image.leave_edit_mode current_user.id
    @image.enter_edit_mode current_user.id
  end
  
  # === Description
  #
  # Adds texts to the image
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * ImageEditorController#initialize_image_with_owner_or_public
  #
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
  
  # === Description
  #
  # Undoes the last modification to the image
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * ImageEditorController#initialize_image_with_owner_or_public
  #
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
  
  # === Description
  #
  # Crops the image
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * ImageEditorController#initialize_image_with_owner_or_public
  #
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
  
  # === Description
  #
  # Saves the image as a new element
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * ImageEditorController#initialize_image_with_owner_or_public
  #
  def save
    if @ok
      @image.enter_edit_mode current_user.id
      @redirect = false
      new_image = Image.new
      new_image.title = params[:new_title_placeholder] != '0' ? '' : params[:new_title]
      new_image.description = params[:new_description_placeholder] != '0' ? '' : params[:new_description]
      new_image.tags = params[:new_tags_value]
      new_image.user_id = current_user.id
      new_image.media = File.open @image.current_editing_image
      new_image.validating_in_form = true
      if !new_image.save
        @error_ids = 'new'
        @errors = convert_item_error_messages(new_image.errors.messages)
        @error_fields = new_image.errors.messages.keys
      end
    else
      @redirect = true
    end
    render 'media_elements/info_form_in_editor/save'
  end
  
  # === Description
  #
  # Saves the image overwriting an existing element
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * ImageEditorController#initialize_image_with_owner_and_private
  #
  def overwrite
    if @ok
      @redirect = false
      @image.enter_edit_mode current_user.id
      @image.title = params[:update_title]
      @image.description = params[:update_description]
      @image.tags = params[:update_tags_value]
      @image.media = File.open @image.current_editing_image
      @image.validating_in_form = true
      if !@image.save
        @error_ids = 'update'
        @errors = convert_item_error_messages(@image.errors.messages)
        @error_fields = @image.errors.messages.keys
      else
        MediaElementsSlide.where(:media_element_id => @image.id).each do |mes|
          mes.alignment = 0
          mes.save
        end
      end
    else
      @redirect = true
    end
    render 'media_elements/info_form_in_editor/save'
  end
  
  private
  
  def extract_textareas_params(params) # :doc:
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
  
  def initialize_image_with_owner_or_public # :doc:
    @image_id = correct_integer?(params[:image_id]) ? params[:image_id].to_i : 0
    @image = Image.find_by_id @image_id
    update_ok(!@image.nil? && (@image.is_public || current_user.id == @image.user_id))
  end
  
  def initialize_image_with_owner_and_private # :doc:
    @image_id = correct_integer?(params[:image_id]) ? params[:image_id].to_i : 0
    @image = Image.find_by_id @image_id
    update_ok(!@image.nil? && !@image.is_public && current_user.id == @image.user_id)
  end
  
end
