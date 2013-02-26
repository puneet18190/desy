require 'media/audio/uploader'
require 'media/audio/editing/parameters'

class Audio < MediaElement
  
  extend Media::Audio::Editing::Parameters
  
  EXTENSION_WHITE_LIST = Media::Audio::Uploader::EXTENSION_WHITE_LIST

  THUMB_URL = '/assets/simbolo-audio.svg'

  after_save :upload_or_copy
  before_destroy :cannot_destroy_while_converting
  after_destroy :clean

  attr_accessor :skip_conversion, :rename_media

  validate :media_validation
  
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
  
  def media
    @media || ( 
      media = read_attribute(:media)
      media ? Media::Audio::Uploader.new(self, :media, media) : nil 
    )
  end

  def media=(media)
    @media = write_attribute :media, (media.present? ? Media::Audio::Uploader.new(self, :media, media) : nil)
  end

  def reload
    @media = @skip_conversion = @rename_media = nil
    super
  end

  def reload_media
    @media = nil
  end

  private
  def media_validation
    media.validation if media
  end

  def upload_or_copy
    media.upload_or_copy if media
    true
  end
end
