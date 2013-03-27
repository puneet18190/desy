require 'media/audio/uploader'
require 'media/audio/editing/parameters'
require 'media/shared'

# == Description
#
# This class inherits from MediaElement, and contains the specific methods needed for media elements of type +audio+. For methods shared by elements of type +audio+ and +video+, see Media::Shared.
# 
class Audio < MediaElement
  UPLOADER = Media::Audio::Uploader
  EXTENSION_WHITE_LIST = UPLOADER::EXTENSION_WHITE_LIST
  CACHE_RESTORE_PATH = '/audios/cache/restore'
  THUMB_URL = '/assets/simbolo-audio.svg'
  
  include Media::Shared
  extend Media::Audio::Editing::Parameters
  
  # == Description
  #
  # Returns the url for the audio in format +mp3+
  #
  # == Args
  #
  # No args required
  #
  # == Returns
  #
  # The url of the mp3 file attached to this audio
  #
  # == Usage
  #
  #   <audio>
  #     <source src="<%= audio.mp3_url %>" type="audio/mp3">
  #   </audio>
  #
  def mp3_url
    media.try(:url, :mp3) if converted
  end
  
  # == Description
  #
  # Returns the url for the audio in format +ogg+
  #
  # == Args
  #
  # No args required
  #
  # == Returns
  #
  # The url of the ogg file attached to this audio
  #
  # == Usage
  #
  #   <audio>
  #     <source src="<%= audio.ogg_url %>" type="audio/ogg">
  #   </audio>
  #
  def ogg_url
    media.try(:url, :ogg) if converted
  end
  
  # == Description
  #
  # Returns the url of the thumb image used in the section "elements" (a musical note on grey bottom).
  #
  # == Args
  #
  # No args required
  #
  # == Returns
  #
  # The url of the thumb (an image).
  #
  # == Usage
  #
  #   <%= image_tag audio.thumb_url %>
  #
  def thumb_url
    converted ? THUMB_URL : placeholder_url(:thumb)
  end
  
  # == Description
  #
  # Returns the url of the placeholder used in case the audio is being converted (an animated gif).
  #
  # == Args
  #
  # +type+::
  #   TODO
  #
  # == Returns
  #
  # The url of the thumb (an image).
  #
  # == Usage
  #
  #   <%= image_tag audio.thumb_url %>
  #
  def placeholder_url(type)
    "/assets/placeholders/audio_#{type}.gif"
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
