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
  # == Returns
  #
  # An url.
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
  # == Returns
  #
  # An url.
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
  # Returns the url of the thumb image used in the section "elements" (a musical note on grey bottom). If the audio is not converted, returns the animated gif from Audio#placeholder_url with +type+=+thumb+.
  #
  # == Returns
  #
  # An url.
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
  # * *type*: the type of placeholder required: it can be
  #   * +:thumb+: used in the expanded media element
  #   * +:lesson_viewer+: used in the lesson viewer
  #
  # == Returns
  #
  # An url.
  #
  # == Usage
  #
  #   <% if audio.converted? %>
  #     <%= render :partial => 'shared/players/audio', :locals => {:audio => audio} %>
  #   <% else %>
  #     <%= image_tag audio.placeholder_url(:lesson_viewer) %>
  #   <% end %>
  #
  def placeholder_url(type)
    "/assets/placeholders/audio_#{type}.gif"
  end
  
  # == Description
  #
  # Returns the float duration in seconds of the mp3 track;
  #
  # == Returns
  #
  # A float.
  #
  def mp3_duration
    metadata.mp3_duration
  end
  
  # == Description
  #
  # Returns the float duration in seconds of the ogg track;
  #
  # == Returns
  #
  # A float.
  #
  def ogg_duration
    metadata.ogg_duration
  end
  
  # == Description
  #
  # Sets the float duration in seconds of the mp3 track;
  #
  # == Args
  #
  # * *mp3_duration*: the duration to be set
  #
  def mp3_duration=(mp3_duration)
    metadata.mp3_duration = mp3_duration
  end
  
  # == Description
  #
  # Sets the float duration in seconds of the ogg track;
  #
  # == Args
  #
  # * *ogg_duration*: the duration to be set
  #
  def ogg_duration=(ogg_duration)
    metadata.ogg_duration = ogg_duration
  end
  
  # == Description
  #
  # Returns the lower integer approximation of the minimum between +ogg_duration+ and +mp3_duration+. This is necessary to insert in the html players an integer duration in seconds that can be used without risks.
  #
  # == Returns
  #
  # An integer.
  #
  # == Usage
  #
  #   <div class="audioPlayer _instance_of_player" data-media-type="audio" data-initialized="false" data-duration="<%= audio.min_duration %>">
  #
  def min_duration
    [mp3_duration, ogg_duration].map(&:to_i).min
  end
  
end
