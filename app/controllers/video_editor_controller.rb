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
    @cache = nil
    @parameters = empty_parameters if @parameters.nil?
    @total_length = Video.total_prototype_time(@parameters)
    render :edit
  end
  
  def empty_cache
    @current_user.empty_video_editor_cache
    render :nothing => true
  end
  
  def save_cache
    @parameters = extract_form_parameters
    render :nothing => true
  end
  
  def commit
  end
  
  private
  
  def extract_form_parameters
    
  resp = {}
  
  params.each do |k, v|
    if !(k =~ /_/).nil?
      index = k.split('_').last.to_i
      p = k.gsub("_#{index}", '')
      if ['type', 'video', 'image', 'from', 'until', 'position', 'content', 'background_color', 'text_color', 'duration'].include?(p)
        if resp.has_key? index
          resp[index][p] = extract_single_form_parameter p, v
      end
    end
  end
  
  
  {
    #"type_1" => "video",
    #"video_1" => "1",
    #"from_1" => "1",
    #"until_1" => "14",
    #"position_1" => "1",
    #"type_2" => "text",
    #"content_2" => "Titolo di prova",
    #"background_color_2" => "black",
    #"text_color_2" => "light_blue",
    #"duration_2" => "5",
    #"position_2" => "2",
    #"type_3" => "video",
    #"video_3" => "3",
    #"from_3" => "0",
    #"until_3" => "38",
    #"position_3" => "3",
    #"type_4" => "video",
    #"video_4" => "4",
    #"from_4" => "10",
    #"until_4" => "15",
    #"position_4" => "4",
    #"type_5" => "text",
    #"content_5" => "Secondo titolo di prova",
    #"background_color_5" => "white",
    #"text_color_5" => "green",
    #"duration_5" => "8",
    #"position_5" => "5",
    #"type_6" => "image",
    #"image_6" => "6",
    #"duration_6" => "11",
    #"position_6" => "6",
    #"type_7" => "video",
    #"video_7" => "5",
    #"from_7" => "14",
    #"until_7" => "15",
    #"position_7" => "7",
  }
  
  
  
  
  
  
  
  
  
  
  end
  
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
