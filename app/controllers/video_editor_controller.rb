class VideoEditorController < ApplicationController
  
  before_filter :initialize_video_with_owner_or_public, :only => :edit
  before_filter :extract_cache, :only => [:edit, :new, :restore_cache]
  layout 'media_element_editor'
  
  def edit
    if @ok
      @parameters = convert_video_to_parameters
      @parameters = empty_parameters if @parameters.nil?
      @total_length = Video.total_prototype_time(@parameters)
    else
      redirect_to dashboard_index_path
      return
    end
  end
  
  def new
    @parameters = empty_parameters
    @total_length = Video.total_prototype_time(@parameters)
    render :edit
  end
  
  def restore_cache
    @parameters = @cache.nil? ? empty_parameters : @cache
    @cache = nil
    @total_length = Video.total_prototype_time(@parameters)
    render :edit
  end
  
  def empty_cache
    @current_user.empty_video_editor_cache
    render :nothing => true
  end
  
  def save_cache
    @current_user.save_video_editor_cache(extract_form_parameters)
    render :nothing => true
  end
  
  def save
    parameters = Video.convert_parameters(extract_form_parameters, @current_user.id)
    if parameters.nil?
      @current_user.empty_video_editor_cache
      redirect_to '/dashboard' # FIXME decidere che fare in questo caso
      return
    end
    parameters[:initial_video] = Video.new
    parameters[:initial_video].title = params[:new_title]
    parameters[:initial_video].description = params[:new_description]
    parameters[:initial_video].tags = params[:new_tags]
    parameters[:initial_video].user_id = @current_user.id
    temporary_initial_video = parameters[:initial_video]
    # provo a validarlo per vedere se è ok
    temporary_initial_video.valid?
    errors = temporary_initial_video.errors.messages
    errors.delete(:media)
    if errors.empty?
      # manda parameters al video editor di Maurizio, e fai redirect_to my_media_elements_path
      # usa le notifiche per segnalare la riuscita o non riuscita del salvataggio??
      # svuota la cache se il salvataggio riesce
    else
      # rispondi JS! creare un file .js.erb, devo ritornare al form iniziale!
    end
  end
  
  def overwrite
    parameters = Video.convert_parameters(extract_form_parameters, @current_user.id)
    if parameters.nil?
      @current_user.empty_video_editor_cache
      redirect_to '/dashboard' # FIXME decidere che fare in questo caso
      return
    end
    parameters[:initial_video].title = params[:update_title]
    parameters[:initial_video].description = params[:update_description]
    parameters[:initial_video].tags = params[:update_tags]
    if parameters[:initial_video].valid?
      # manda parameters al video editor di Maurizio, e fai redirect_to my_media_elements_path
      # usa le notifiche per segnalare la riuscita o non riuscita del salvataggio??
      # svuota la cache se il salvataggio riesce
    else
      # rispondi JS! creare un file .js.erb, devo ritornare al form iniziale!
    end
  end
  
  private
  
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
    resp[:components].first[:type] = Video::VIDEO_COMPONENT
    resp[:components].first[:video_id] = @video.id
    resp[:components].first[:from] = 0
    resp[:components].first[:to] = @video.min_duration
    resp = Video.convert_parameters(resp, @current_user.id)
    resp.nil? ? empty_parameters : resp
  end
  
  def empty_parameters
    resp = {}
    resp[:initial_video] = nil
    resp[:audio] = nil
    resp[:components] = []
    resp
  end
  
  def extract_cache
    @cache = Video.convert_parameters @current_user.video_editor_cache, @current_user.id
  end
  
  def initialize_video_with_owner_or_public
    @video_id = correct_integer?(params[:video_id]) ? params[:video_id].to_i : 0
    @video = Video.find_by_id @video_id
    update_ok(!@video.nil? && (@video.is_public || @current_user.id == @video.user_id))
  end
  
end
