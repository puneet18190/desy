require 'media/video/uploader'
require 'media/video/editing/parameters'
require 'media/shared'

# converted
#   true  : conversione andata a buon fine
#   false : conversione non andata a buon fine
#   nil   : conversione da effettuare o in fase di conversione
class Video < MediaElement
  UPLOADER = Media::Video::Uploader
  EXTENSION_WHITE_LIST = UPLOADER::EXTENSION_WHITE_LIST

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
    converted ? media.try(:url, :thumb) : placeholder_url
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

  def pre_overwriting
    # tags non è un attributo, per cui non risulta tra i cambi; 
    # me lo prendo dall'associazione taggings_tags, visto che non è cambiata
    old_fields = Hash[ v.changes.map{ |col, (old)| [col, old] } << ['tags', v.taggings_tags.map(&:word).join(', ')] ]
    self.metadata.old_fields = old_fields
    self.converted = nil
    Base.transaction do
      save!
      disable_lessons_containing_me
    end
  end
  
end
