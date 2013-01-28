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
    initial_audio_test = Audio.new
    initial_audio_test.title = params[:new_title_placeholder] != '0' ? '' : params[:new_title]
    initial_audio_test.description = params[:new_description_placeholder] != '0' ? '' : params[:new_description]
    initial_audio_test.tags = params[:new_tags_value]
    initial_audio_test.user_id = current_user.id
    # provo a validarlo per vedere se è ok
    initial_audio_test.valid?
    errors = initial_audio_test.errors.messages
    errors.delete(:media)
    if errors.empty?
      parameters[:initial_audio] = {
        :id => nil,
        :title => params[:new_title],
        :description => params[:new_description],
        :tags => params[:new_tags],
        :user_id => current_user.id
      }
      #Delayed::Job.enqueue Media::Audio::Editing::Composer::Job.new(parameters)
    else
      @error_ids = 'new'
      @errors = convert_item_error_messages(errors)
      @error_fields = errors.keys
    end
    render 'media_elements/info_form_in_editor/save'
  end
  
  def overwrite
    parameters = Audio.convert_to_primitive_parameters(extract_form_parameters, current_user.id)
    @redirect = false
    if parameters.nil?
      current_user.audio_editor_cache = {}
      @redirect = true
      render 'media_elements/info_form_in_editor/save'
      return
    end
    initial_audio_test = Audio.find_by_id parameters[:initial_audio]
    initial_audio_test.title = params[:update_title]
    initial_audio_test.description = params[:update_description]
    initial_audio_test.tags = params[:update_tags_value]
    if initial_audio_test.valid?
      parameters[:initial_audio] = {
        :id => parameters[:initial_audio],
        :title => params[:update_title],
        :description => params[:update_description],
        :tags => params[:update_tags]
      }
      initial_audio_test.pre_overwriting
      Notification.send_to current_user.id, t('captions.audio_in_conversion_warning')
      Delayed::Job.enqueue Media::Audio::Editing::Composer::Job.new(parameters)
    else
      @error_ids = 'update'
      @errors = convert_item_error_messages(initial_audio_test.errors.messages)
      @error_fields = initial_audio_test.errors.messages.keys
    end
    render 'media_elements/info_form_in_editor/save'
  end
  
  private
  
  def used_in_private_lessons
    return false if @parameters[:initial_audio].nil?
    @parameters[:initial_audio].media_elements_slides.any?
  end
  
  def check_available_for_user
    if !current_user.audio_editor_available
      render 'not_available'
      return
    end
  end
  
  def extract_form_parameters
    # manca
  end
  
  def convert_audio_to_parameters
    resp = {}
    resp[:initial_audio_id] = @audio.is_public ? nil : @audio.id
    resp[:components] = [{}]
    resp[:components].first[:audio_id] = @audio.id
    resp[:components].first[:from] = 0
    resp[:components].first[:to] = @audio.min_duration
    resp = Audio.convert_parameters(resp, current_user.id)
    resp.nil? ? empty_parameters : resp
  end
  
  def empty_parameters
    resp = {}
    resp[:initial_audio] = nil
    resp[:components] = []
    resp
  end
  
  def extract_cache
    @cache = Audio.convert_parameters current_user.audio_editor_cache, current_user.id
  end
  
  def initialize_audio_with_owner_or_public
    @audio_id = correct_integer?(params[:audio_id]) ? params[:audio_id].to_i : 0
    @audio = Audio.find_by_id @audio_id
    update_ok(!@audio.nil? && (@audio.is_public || current_user.id == @audio.user_id))
  end
  
end
