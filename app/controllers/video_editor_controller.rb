class VideoEditorController < ApplicationController
  
  before_filter :convert_video_to_media_element
  before_filter :initialize_media_element_with_owner_or_public, :only => :edit
  before_filter :extract_cache, :only => [:edit, :new]
  layout 'media_element_editor'
  
  def edit
    if @ok
      # FIXME qui in realtà dovrò proporre la finestra oscurata che mi chiede se voglio ripristinare la situazione precedente oppure no
      @parameters = @cache.nil? ? convert_media_element_to_parameters : @cache
    else
      redirect_to dashboard_path
      return
    end
  end
  
  def new
    # FIXME qui in realtà dovrò proporre la finestra oscurata che mi chiede se voglio ripristinare la situazione precedente oppure no
    @parameters = @cache.nil? ? empty_parameters : @cache
    render :edit
  end
  
  def save_cache
  end
  
  def commit
  end
  
  private
  
  def convert_media_element_to_parameters
    return nil if @media_element.nil?
    resp = {}
    resp[:initial_video_id] = @media_element.is_public ? nil : @media_element.id
    resp[:audio_id] = nil
    resp[:parameters] = [{}]
    resp[:parameters].first[:component] = Video::VIDEO_COMPONENT
    resp[:parameters].first[:video_id] = @media_element.id
    resp[:parameters].first[:from] = 0
    resp[:parameters].first[:until] = @media_element.duration
    resp = Video.convert_parameters(resp, @current_user.id)
    resp.nil? ? empty_parameters : resp
  end
  
  def empty_parameters
    resp = {}
    resp[:initial_video] = nil
    resp[:audio] = nil
    resp[:parameters] = []
    resp
  end
  
  def extract_cache
    @cache = @current_user.video_editor_cache
  end
  
  def convert_video_to_media_element
    if params.has_key? :video_id
      x = params[:video_id]
      params.delete :video_id
      params[:media_element_id] = x
    end
  end
  
end
