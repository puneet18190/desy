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
    @parameters = @cache.nil? ? empty_parameters : Video.convert_parameters(@cache, @current_user.id)
    @parameters = empty_parameters if @parameters.nil?
    @total_length = Video.total_prototype_time(@parameters)
    render :edit
  end
  
  def empty_cache
  end
  
  def save_cache
  end
  
  def commit
  end
  
  private
  
  def convert_video_to_parameters
    resp = {}
    resp[:initial_video_id] = @video.is_public ? nil : @video.id
    resp[:audio_id] = nil
    resp[:components] = [{}]
    resp[:components].first[:type] = Video::VIDEO_COMPONENT
    resp[:components].first[:video_id] = @video.id
    resp[:components].first[:from] = 0
    resp[:components].first[:until] = @video.min_duration
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
    @cache = @current_user.video_editor_cache
  end
  
  def initialize_video_with_owner_or_public
    @video_id = correct_integer?(params[:video_id]) ? params[:video_id].to_i : 0
    @video = Video.find_by_id @video_id
    update_ok(!@video.nil? && (@video.is_public || @current_user.id == @video.user_id))
  end
  
end
