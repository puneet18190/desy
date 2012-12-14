class GalleriesController < ApplicationController
  
  IMAGES_FOR_PAGE = CONFIG['images_for_page_in_gallery']
  AUDIOS_FOR_PAGE = CONFIG['audios_for_page_in_gallery']
  VIDEOS_FOR_PAGE = CONFIG['videos_for_page_in_gallery']
  
  def image_for_lesson_editor
    get_images
  end
  
  def image_for_image_editor
    get_images
    render :layout => 'media_element_editor'
  end
  
  def audio_for_lesson_editor
    get_audios
  end
  
  def video_for_lesson_editor
    get_videos
  end
  
  def mixed_for_video_editor
    get_images
    get_videos
  end
  
  def audio_for_video_editor
    get_audios
  end
  
  def audio_for_audio_editor
    get_audios
  end
  
  private
  
  def get_audios
    @audios = @current_user.own_media_elements(1, AUDIOS_FOR_PAGE, Filters::AUDIO)[:records]
  end
  
  def get_videos
    @videos = @current_user.own_media_elements(1, VIDEOS_FOR_PAGE, Filters::VIDEO)[:records]
  end
  
  def get_images
    @images = @current_user.own_media_elements(1, IMAGES_FOR_PAGE, Filters::IMAGE)[:records]
  end
  
end
