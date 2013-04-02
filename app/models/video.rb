require 'media/video/uploader'
require 'media/video/editing/parameters'
require 'media/shared'

class Video < MediaElement
  UPLOADER = Media::Video::Uploader
  EXTENSION_WHITE_LIST = UPLOADER::EXTENSION_WHITE_LIST
  CACHE_RESTORE_PATH = '/videos/cache/restore'
  
  include Media::Shared
  extend  Media::Video::Editing::Parameters
  
  def min_duration
    [mp4_duration, webm_duration].map(&:to_i).min
  end
  
  def mp4_url
    media.try(:url, :mp4) if converted
  end
  
  def webm_url
    media.try(:url, :webm) if converted
  end
  
  def cover_url
    media.try(:url, :cover) if converted
  end
  
  def thumb_url
    media.try(:url, :thumb) if converted
  end
  
  def placeholder_url(type)
    "/assets/placeholders/video_#{type}.gif"
  end
  
  def mp4_duration
    converted ? metadata.mp4_duration : nil
  end
  
  def mp4_duration=(mp4_duration)
    metadata.mp4_duration = mp4_duration
  end
  
  def webm_duration
    converted ? metadata.webm_duration : nil
  end
  
  def webm_duration=(webm_duration)
    metadata.webm_duration = webm_duration
  end
  
end
