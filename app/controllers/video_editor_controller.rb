class VideoEditorController < ApplicationController
  
  before_filter :convert_media_element_to_video
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
    render :edit
  end
  
  private
  
  def convert_media_element_to_parameters
    return nil if @media_element.nil?
    resp = {}
#    resp[:initial_video_id] = @media_element.
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
