class GalleriesController < ApplicationController
  
  IMAGES_FOR_PAGE = CONFIG['images_for_page_in_gallery']
  AUDIOS_FOR_PAGE = CONFIG['audios_for_page_in_gallery']
  VIDEOS_FOR_PAGE = CONFIG['videos_for_page_in_gallery']
  
  # _show_image_gallery_in_lesson_editor
  def image_for_lesson_editor
    @images = @current_user.own_media_elements(1, IMAGES_FOR_PAGE, Filters::IMAGE)[:records]
  end
  
  # _show_audio_gallery_in_lesson_editor
  def audio_for_lesson_editor
    @audios = @current_user.own_media_elements(1, AUDIOS_FOR_PAGE, Filters::AUDIO)[:records]
  end
  
  def video_for_lesson_editor
    @videos = @current_user.own_media_elements(1, VIDEOS_FOR_PAGE, Filters::VIDEO)[:records]
  end
  
  def image_for_video_editor
    @images = @current_user.own_media_elements(1, IMAGES_FOR_PAGE, Filters::IMAGE)[:records]
  end
  
  def audio_for_video_editor
    @audios = @current_user.own_media_elements(1, AUDIOS_FOR_PAGE, Filters::AUDIO)[:records]
  end
  
  def video_for_video_editor
    @videos = @current_user.own_media_elements(1, VIDEOS_FOR_PAGE, Filters::VIDEO)[:records]
  end
  
  def audio_for_audio_editor
    @audios = @current_user.own_media_elements(1, AUDIOS_FOR_PAGE, Filters::AUDIO)[:records]
  end
  
end
