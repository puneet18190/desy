# == Description
#
# List of actions to handle all the instances of galleries in the application. Since the gallery pagination is made with infinite scroll, for each gallery there is an action that extracts it first, and another one that gets a new block of elements. List of galleries for each section
# * Lesson Editor (see LessonEditorController):
#   * audio gallery
#     * GalleriesController#audio_for_lesson_editor
#     * GalleriesController#audio_for_lesson_editor_new_block
#   * image gallery
#     * GalleriesController#image_for_lesson_editor
#     * GalleriesController#image_for_lesson_editor_new_block
#   * video gallery
#     * GalleriesController#video_for_lesson_editor
#     * GalleriesController#video_for_lesson_editor_new_block
# * Image Editor (see ImageEditorController):
#   * image gallery
#     * GalleriesController#image_for_image_editor
#     * GalleriesController#image_for_image_editor_new_block
# * Audio Editor (see AudioEditorController):
#   * audio gallery
#     * GalleriesController#audio_for_audio_editor
#     * GalleriesController#audio_for_audio_editor_new_block
# * Video Editor (see VideoEditorController):
#   * mixed gallery (video + image + texts)
#     * GalleriesController#mixed_for_video_editor
#     * GalleriesController#mixed_for_video_editor_video_new_block
#     * GalleriesController#mixed_for_video_editor_image_new_block
#
# == Models used
#
# * User
# * Image
# * Audio
# * Video
#
class GalleriesController < ApplicationController
  
  # Number of images for page, configured in settings.yml
  IMAGES_FOR_PAGE = SETTINGS['images_for_page_in_gallery']
  
  # Number of audios for page, configured in settings.yml
  AUDIOS_FOR_PAGE = SETTINGS['audios_for_page_in_gallery']
  
  # Number of videos for page, configured in settings.yml
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
  
  def initialize_page # :doc:
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 0
    update_ok(@page > 0)
  end
  
  def get_audios(page) # :doc:
    x = current_user.own_media_elements(page, AUDIOS_FOR_PAGE, Filters::AUDIO)
    @audios = x[:records]
    @tot_pages = x[:pages_amount]
  end
  
  def get_videos(page) # :doc:
    x = current_user.own_media_elements(page, VIDEOS_FOR_PAGE, Filters::VIDEO)
    @videos = x[:records]
    @tot_pages = x[:pages_amount]
  end
  
  def get_images(page) # :doc:
    x = current_user.own_media_elements(page, IMAGES_FOR_PAGE, Filters::IMAGE)
    @images = x[:records]
    @tot_pages = x[:pages_amount]
  end
  
end
