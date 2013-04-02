require 'media/audio/editing/composer/job'

class AudioEditorController < ApplicationController
  
  before_filter :check_available_for_user
  before_filter :initialize_audio_with_owner_or_public, :only => :edit
  before_filter :extract_cache, :only => [:edit, :new, :restore_cache]
  layout 'media_element_editor'
  
  def edit
    if @ok
      @parameters = convert_audio_to_parameters
      @total_length = Audio.total_prototype_time(@parameters)
      @used_in_private_lessons = used_in_private_lessons
      @back = params[:back] if params[:back].present?
    else
      redirect_to dashboard_path
      return
    end
  end
  
  def new
    @parameters = empty_parameters
    @total_length = Audio.total_prototype_time(@parameters)
    @used_in_private_lessons = used_in_private_lessons
    @back = params[:back] if params[:back].present?
    render :edit
  end
  
  def restore_cache
    @parameters = @cache.nil? ? empty_parameters : @cache
    @cache = nil
    @total_length = Audio.total_prototype_time(@parameters)
    @used_in_private_lessons = used_in_private_lessons
    render :edit
  end
  
  def empty_cache
    current_user.audio_editor_cache!
    render :nothing => true
  end
  
  def save_cache
    current_user.audio_editor_cache! extract_form_parameters
    render :nothing => true
  end
  
  def save
    parameters = Audio.convert_to_primitive_parameters(extract_form_parameters, current_user.id)
    @redirect = false
    if parameters.nil?
      current_user.audio_editor_cache!
      @redirect = true
      render 'media_elements/info_form_in_editor/save'
      return
    end
    record = Audio.new do |r|
      r.title       = params[:new_title_placeholder] != '0' ? '' : params[:new_title]
      r.description = params[:new_description_placeholder] != '0' ? '' : params[:new_description]
      r.tags        = params[:new_tags_value]
      r.user_id     = current_user.id
      r.composing   = true
      r.validating_in_form = true
    end
    if record.save
      parameters[:initial_audio] = {:id => record.id}
      Notification.send_to current_user.id, t('notifications.audio.compose.create.started', item: record.title)
      Delayed::Job.enqueue Media::Audio::Editing::Composer::Job.new(parameters)
    else
      @error_ids = 'new'
      @errors = convert_item_error_messages(record.errors.messages)
      @error_fields = record.errors.messages.keys
    end
    render 'media_elements/info_form_in_editor/save'
  end
  
  def overwrite
    parameters = Audio.convert_to_primitive_parameters(extract_form_parameters, current_user.id)
    @redirect = false
    if parameters.nil?
      current_user.audio_editor_cache!
      @redirect = true
      render 'media_elements/info_form_in_editor/save'
      return
    end
    record = Audio.find_by_id parameters[:initial_audio]
    record.title = params[:update_title]
    record.description = params[:update_description]
    record.tags = params[:update_tags_value]
    record.validating_in_form = true
    if record.valid?
      parameters[:initial_audio] = {
        :id => parameters[:initial_audio],
        :title => params[:update_title],
        :description => params[:update_description],
        :tags => params[:update_tags_value]
      }
      record.overwrite!
      Notification.send_to current_user.id, t('notifications.audio.compose.update.started', item: record.title)
      Delayed::Job.enqueue Media::Audio::Editing::Composer::Job.new(parameters)
    else
      @error_ids = 'update'
      @errors = convert_item_error_messages(record.errors.messages)
      @error_fields = record.errors.messages.keys
    end
    render 'media_elements/info_form_in_editor/save'
  end
  
  private
  
  def used_in_private_lessons # :doc:
    return false if @parameters[:initial_audio].nil?
    @parameters[:initial_audio].media_elements_slides.any?
  end
  
  def check_available_for_user # :doc:
    if !current_user.audio_editor_available
      render 'not_available'
      return
    end
  end
  
  def extract_form_parameters # :doc:
    unordered_resp = {}
    ordered_resp = {}
    resp = {
      :initial_audio_id => params[:initial_audio_id].blank? ? nil : params[:initial_audio_id].to_i,
      :components => []
    }
    params.each do |k, v|
      if !(k =~ /_/).nil?
        index = k.split('_').last.to_i
        p = k.gsub("_#{index}", '')
        if ['audio_id', 'from', 'to', 'position'].include?(p)
          if unordered_resp.has_key? index
            unordered_resp[index][:"#{p}"] = v.to_i
          else
            unordered_resp[index] = {:"#{p}" => v.to_i}
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
  
  def convert_audio_to_parameters # :doc:
    resp = {}
    resp[:initial_audio_id] = @audio.is_public ? nil : @audio.id
    resp[:components] = [{}]
    resp[:components].first[:audio_id] = @audio.id
    resp[:components].first[:from] = 0
    resp[:components].first[:to] = @audio.min_duration
    resp = Audio.convert_parameters(resp, current_user.id)
    resp.nil? ? empty_parameters : resp
  end
  
  def empty_parameters # :doc:
    resp = {}
    resp[:initial_audio] = nil
    resp[:components] = []
    resp
  end
  
  def extract_cache # :doc:
    @cache = Audio.convert_parameters current_user.audio_editor_cache, current_user.id
  end
  
  def initialize_audio_with_owner_or_public # :doc:
    @audio_id = correct_integer?(params[:audio_id]) ? params[:audio_id].to_i : 0
    @audio = Audio.find_by_id @audio_id
    update_ok(!@audio.nil? && (@audio.is_public || current_user.id == @audio.user_id))
  end
  
end
