require 'media/video/editing/composer/job'

class VideoEditorController < ApplicationController
  
  before_filter :check_available_for_user
  before_filter :initialize_video_with_owner_or_public, :only => :edit
  before_filter :extract_cache, :only => [:edit, :new, :restore_cache]
  layout 'media_element_editor'
  
  def edit
    if @ok
      @parameters = convert_video_to_parameters
      @total_length = Video.total_prototype_time(@parameters)
      @used_in_private_lessons = used_in_private_lessons
    else
      redirect_to dashboard_path
      return
    end
  end
  
  def new
    @parameters = empty_parameters
    @total_length = Video.total_prototype_time(@parameters)
    @used_in_private_lessons = used_in_private_lessons
    render :edit
  end
  
  def restore_cache
    @parameters = @cache.nil? ? empty_parameters : @cache
    @cache = nil
    @total_length = Video.total_prototype_time(@parameters)
    @used_in_private_lessons = used_in_private_lessons
    render :edit
  end
  
  def empty_cache
    current_user.empty_video_editor_cache
    render :nothing => true
  end
  
  def save_cache
    current_user.save_video_editor_cache(extract_form_parameters)
    render :nothing => true
  end
  
  def save
    parameters = Video.convert_to_primitive_parameters(extract_form_parameters, current_user.id)
    @redirect = false
    if parameters.nil?
      current_user.empty_video_editor_cache
      @redirect = true
      render 'media_elements/info_form_in_editor/save'
      return
    end
    initial_video_test = Video.new
    initial_video_test.title = params[:new_title_placeholder] != '0' ? '' : params[:new_title]
    initial_video_test.description = params[:new_description_placeholder] != '0' ? '' : params[:new_description]
    initial_video_test.tags = params[:new_tags_placeholder] != '0' ? '' : params[:new_tags]
    initial_video_test.user_id = current_user.id
    # provo a validarlo per vedere se è ok
    initial_video_test.valid?
    errors = initial_video_test.errors.messages
    errors.delete(:media)
    if errors.empty?
      parameters[:initial_video] = {
        :id => nil,
        :title => params[:new_title],
        :description => params[:new_description],
        :tags => params[:new_tags],
        :user_id => current_user.id
      }
      Delayed::Job.enqueue Media::Video::Editing::Composer::Job.new(parameters)
    else
      @error_ids = 'new'
      @errors = convert_item_error_messages(errors)
      @error_fields = errors.keys
    end
    render 'media_elements/info_form_in_editor/save'
  end
  
  def overwrite
    parameters = Video.convert_to_primitive_parameters(extract_form_parameters, current_user.id)
    @redirect = false
    if parameters.nil?
      current_user.empty_video_editor_cache
      @redirect = true
      render 'media_elements/info_form_in_editor/save'
      return
    end
    initial_video_test = Video.find_by_id parameters[:initial_video]
    initial_video_test.title = params[:update_title]
    initial_video_test.description = params[:update_description]
    initial_video_test.tags = params[:update_tags]
    if initial_video_test.valid?
      parameters[:initial_video] = {
        :id => parameters[:initial_video],
        :title => params[:update_title],
        :description => params[:update_description],
        :tags => params[:update_tags]
      }
      initial_video_test.pre_overwriting
      Notification.send_to current_user.id, t('captions.video_in_conversion_warning')
      Delayed::Job.enqueue Media::Video::Editing::Composer::Job.new(parameters)
    else
      @error_ids = 'update'
      @errors = convert_item_error_messages(initial_video_test.errors.messages)
      @error_fields = initial_video_test.errors.messages.keys
    end
    render 'media_elements/info_form_in_editor/save'
  end
  
  private
  
  def used_in_private_lessons
    return false if @parameters[:initial_video].nil?
    @parameters[:initial_video].media_elements_slides.any?
  end
  
  def check_available_for_user
    if !current_user.video_editor_available
      render 'not_available'
      return
    end
  end
  
  def extract_single_form_parameter(p, value)
    if ['type', 'content', 'background_color', 'text_color'].include? p
      return value
    elsif ['position', 'video_id', 'image_id', 'from', 'to', 'duration'].include? p
      return value.to_i
    else
      return nil
    end
  end
  
  def extract_form_parameters
    unordered_resp = {}
    ordered_resp = {}
    resp = {
      :initial_video_id => params[:initial_video_id].blank? ? nil : params[:initial_video_id].to_i,
      :audio_id => params[:audio_id].blank? ? nil : params[:audio_id].to_i,
      :components => []
    }
    params.each do |k, v|
      if !(k =~ /_/).nil?
        index = k.split('_').last.to_i
        p = k.gsub("_#{index}", '')
        if ['type', 'video_id', 'image_id', 'from', 'to', 'position', 'content', 'background_color', 'text_color', 'duration'].include?(p)
          if unordered_resp.has_key? index
            unordered_resp[index][:"#{p}"] = extract_single_form_parameter(p, v)
          else
            unordered_resp[index] = {:"#{p}" => extract_single_form_parameter(p, v)}
          end
        end
      end
    end
    unordered_resp.each do |k, v|
      ordered_resp[v[:position]] = v
      ordered_resp[v[:position]].delete(:position)
    end
    ordered_resp.sort.each do |item|
      resp[:components] << item[1]
    end
    resp
  end
  
  def convert_video_to_parameters
    resp = {}
    resp[:initial_video_id] = @video.is_public ? nil : @video.id
    resp[:audio_id] = nil
    resp[:components] = [{}]
    resp[:components].first[:type] = Media::Video::Editing::Parameters::VIDEO_COMPONENT
    resp[:components].first[:video_id] = @video.id
    resp[:components].first[:from] = 0
    resp[:components].first[:to] = @video.min_duration
    resp = Video.convert_parameters(resp, current_user.id)
    resp.nil? ? empty_parameters : resp
  end
  
  def empty_parameters
    resp = {}
    resp[:initial_video] = nil
    resp[:audio_track] = nil
    resp[:components] = []
    resp
  end
  
  def extract_cache
    @cache = Video.convert_parameters current_user.video_editor_cache, current_user.id
  end
  
  def initialize_video_with_owner_or_public
    @video_id = correct_integer?(params[:video_id]) ? params[:video_id].to_i : 0
    @video = Video.find_by_id @video_id
    update_ok(!@video.nil? && (@video.is_public || current_user.id == @video.user_id))
  end
  
end
