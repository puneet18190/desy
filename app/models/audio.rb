require 'media/audio/uploader'
require 'media/audio/editing/parameters'
require 'media/shared'

class Audio < MediaElement
  UPLOADER = Media::Audio::Uploader
  EXTENSION_WHITE_LIST = UPLOADER::EXTENSION_WHITE_LIST
  THUMB_URL = '/assets/simbolo-audio.svg'

  include Media::Shared
  extend Media::Audio::Editing::Parameters

  def mp3_url
    media.try(:url, :mp3) if converted
  end

  def ogg_url
    media.try(:url, :ogg) if converted
  end
  
  def thumb_url
    converted ? THUMB_URL : placeholder_url
  end
  
  def mp3_duration
    metadata.mp3_duration
  end
  
  def ogg_duration
    metadata.ogg_duration
  end

  def mp3_duration=(mp3_duration)
    metadata.mp3_duration = mp3_duration
  end
  
  def ogg_duration=(ogg_duration)
    metadata.ogg_duration = ogg_duration
  end

  def min_duration
    [mp3_duration, ogg_duration].map(&:to_i).min
  end
end
