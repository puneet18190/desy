class GalleriesController < ApplicationController
  
  IMAGES_FOR_PAGE = SETTINGS['images_for_page_in_gallery']
  AUDIOS_FOR_PAGE = SETTINGS['audios_for_page_in_gallery']
  VIDEOS_FOR_PAGE = SETTINGS['videos_for_page_in_gallery']
  
  before_filter :initialize_page, :only => [
    :image_for_lesson_editor_new_block,
    :audio_for_lesson_editor_new_block,
    :video_for_lesson_editor_new_block,
    :mixed_for_video_editor_image_new_block,
    :mixed_for_video_editor_video_new_block,
    :audio_for_video_editor_new_block,
    :audio_for_audio_editor_new_block,
    :image_for_image_editor_new_block
  ]
  
  
  # IMAGE IN LESSON EDITOR
  
  def image_for_lesson_editor
    get_images(1)
  end
  
  def image_for_lesson_editor_new_block
    if @ok
      get_images(@page)
    else
      render :nothing => true
    end
  end
  
  
  # AUDIO IN LESSON EDITOR
  
  def audio_for_lesson_editor
    get_audios(1)
  end
  
  def audio_for_lesson_editor_new_block
    if @ok
      get_audios(@page)
    else
      render :nothing => true
    end
  end
  
  
  # VIDEO IN LESSON EDITOR
  
  def video_for_lesson_editor
    get_videos(1)
  end
  
  def video_for_lesson_editor_new_block
    if @ok
      get_videos(@page)
    else
      render :nothing => true
    end
  end
  
  
  # MIXED VIDEO + IMAGE + TEXT IN VIDEO EDITOR
  
  def mixed_for_video_editor
    get_images(1)
    @image_tot_pages = @tot_pages
    get_videos(1)
    @video_tot_pages = @tot_pages
  end
  
  def mixed_for_video_editor_image_new_block
    if @ok
      get_images(@page)
    else
      render :nothing => true
    end
  end
  
  def mixed_for_video_editor_video_new_block
    if @ok
      get_videos(@page)
    else
      render :nothing => true
    end
  end
  
  
  # AUDIO IN VIDEO EDITOR
  
  def audio_for_video_editor
    get_audios(1)
  end
  
  def audio_for_video_editor_new_block
    if @ok
      get_audios(@page)
    else
      render :nothing => true
    end
  end
  
  
  # AUDIO IN AUDIO EDITOR
  
  def audio_for_audio_editor
    get_audios(1)
  end
  
  def audio_for_audio_editor_new_block
    if @ok
      get_audios(@page)
    else
      render :nothing => true
    end
  end
  
  
  # IMAGE IN IMAGE EDITOR
  
  def image_for_image_editor
    get_images(1)
    @back = params[:back] if params[:back].present?
    render :layout => 'media_element_editor'
  end
  
  def image_for_image_editor_new_block
    if @ok
      get_images(@page)
    else
      render :nothing => true
    end
  end
  
  
  private
  
  def initialize_page
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 0
    update_ok(@page > 0)
  end
  
  def get_audios(page)
    x = current_user.own_media_elements(page, AUDIOS_FOR_PAGE, Filters::AUDIO)
    @audios = x[:records]
    @tot_pages = x[:pages_amount]
  end
  
  def get_videos(page)
    x = current_user.own_media_elements(page, VIDEOS_FOR_PAGE, Filters::VIDEO)
    @videos = x[:records]
    @tot_pages = x[:pages_amount]
  end
  
  def get_images(page)
    x = current_user.own_media_elements(page, IMAGES_FOR_PAGE, Filters::IMAGE)
    @images = x[:records]
    @tot_pages = x[:pages_amount]
  end
  
end
