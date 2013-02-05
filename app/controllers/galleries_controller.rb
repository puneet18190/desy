class GalleriesController < ApplicationController
  
  IMAGES_FOR_PAGE = SETTINGS['images_for_page_in_gallery']
  AUDIOS_FOR_PAGE = SETTINGS['audios_for_page_in_gallery']
  VIDEOS_FOR_PAGE = SETTINGS['videos_for_page_in_gallery']
  
  
  # IMAGE IN LESSON EDITOR
  
  def image_for_lesson_editor
    get_images
  end
  
  def image_for_lesson_editor_new_block
    
  end
  
  
  # AUDIO IN LESSON EDITOR
  
  def audio_for_lesson_editor
    get_audios
  end
  
  def audio_for_lesson_editor_new_block
    
  end
  
  
  # VIDEO IN LESSON EDITOR
  
  def video_for_lesson_editor
    get_videos
  end
  
  def video_for_lesson_editor_new_block
    
  end
  
  
  # MIXED VIDEO + IMAGE + TEXT IN VIDEO EDITOR
  
  def mixed_for_video_editor
    get_images
    get_videos
  end
  
  def mixed_for_video_editor_image_new_block
    
  end
  
  def mixed_for_video_editor_video_new_block
    
  end
  
  
  # AUDIO IN VIDEO EDITOR
  
  def audio_for_video_editor
    get_audios
  end
  
  def audio_for_video_editor_new_block
    
  end
  
  
  # AUDIO IN AUDIO EDITOR
  
  def audio_for_audio_editor
    get_audios
  end
  
  def audio_for_audio_editor_new_block
    
  end
  
  
  # IMAGE IN IMAGE EDITOR
  
  def image_for_image_editor
    get_images
    @back = params[:back] if params[:back].present?
    render :layout => 'media_element_editor'
  end
  
  def image_for_image_editor_new_block
    
  end
  
  
  private
  
  def get_audios
    @audios = current_user.own_media_elements(1, AUDIOS_FOR_PAGE, Filters::AUDIO)[:records]
  end
  
  def get_videos
    @videos = current_user.own_media_elements(1, VIDEOS_FOR_PAGE, Filters::VIDEO)[:records]
  end
  
  def get_images
    @images = current_user.own_media_elements(1, IMAGES_FOR_PAGE, Filters::IMAGE)[:records]
  end
  
end
