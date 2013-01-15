require 'media/video/uploader'
require 'media/video/placeholder'
require 'media/video/editing/parameters'

# converted
#   true  : conversione andata a buon fine
#   false : conversione non andata a buon fine
#   nil   : conversione da effettuare o in fase di conversione
class Video < MediaElement

  extend Media::Video::Editing::Parameters
  
  EXTENSION_WHITE_LIST = Media::Video::Uploader::EXTENSION_WHITE_LIST
  PLACEHOLDER          = Media::Video::Placeholder

  after_save :upload_or_copy
  before_destroy :cannot_destroy_while_converting
  after_destroy :clean

  attr_accessor :skip_conversion, :rename_media

  validate :media_validation
  
  def min_duration
    [mp4_duration, webm_duration].map(&:to_i).min
  end

  def mp4_url
    converted ? media.try(:url, :mp4) : PLACEHOLDER.url(:mp4)
  end

  def webm_url
    converted ? media.try(:url, :webm) : PLACEHOLDER.url(:webm)
  end

  def cover_url
    converted ? media.try(:url, :cover) : PLACEHOLDER.url(:cover)
  end
  
  def thumb_url
    converted ? media.try(:url, :thumb) : PLACEHOLDER.url(:thumb)
  end

  def media
    @media || ( 
      media = read_attribute(:media)
      media ? Media::Video::Uploader.new(self, :media, media) : nil 
    )
  end

  def media=(media)
    @media = write_attribute :media, (media.present? ? Media::Video::Uploader.new(self, :media, media) : nil)
  end

  def mp4_duration
    converted ? metadata.mp4_duration : PLACEHOLDER.mp4_duration
  end
  
  def webm_duration
    converted ? metadata.webm_duration : PLACEHOLDER.webm_duration
  end

  def mp4_duration=(mp4_duration)
    metadata.mp4_duration = mp4_duration
  end
  
  def webm_duration=(webm_duration)
    metadata.webm_duration = webm_duration
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
