require 'media/video/uploader'
require 'media/video/editing/parameters'
require 'media/shared'

# == Description
#
# This class inherits from MediaElement, and contains the specific methods needed for media elements of type +video+. For methods shared by elements of type +audio+ and +video+, see Media::Shared.
# 
class Video < MediaElement
  
  # Instance of specific uploader for a video
  UPLOADER = Media::Video::Uploader
  
  # List of accepted extensions
  EXTENSION_WHITE_LIST = UPLOADER::EXTENSION_WHITE_LIST
  
  # Path for restoring the video editor cache
  CACHE_RESTORE_PATH = '/videos/cache/restore'
  
  include Media::Shared
  extend  Media::Video::Editing::Parameters
  
  # === Description
  #
  # Returns the lower integer approximation of the minimum between +webm_duration+ and +mp4_duration+. This is necessary to insert in the html players an integer duration in seconds that can be used without risks.
  #
  # === Returns
  #
  # An integer.
  #
  # === Usage
  #
  #   <div class="videoPlayer _instance_of_player" data-media-type="video" data-initialized="false" data-duration="<%= video.min_duration %>">
  #
  def min_duration
    [mp4_duration, webm_duration].map(&:to_i).min
  end
  
  # === Description
  #
  # Returns the url for the video in format +mp4+
  #
  # === Returns
  #
  # An url.
  #
  # === Usage
  #
  #   <video>
  #     <source src="<%= video.mp4_url %>" type="video/mp4">
  #   </video>
  #
  def mp4_url
    media.try(:url, :mp4) if converted
  end
  
  # === Description
  #
  # Returns the url for the video in format +webm+
  #
  # === Returns
  #
  # An url.
  #
  # === Usage
  #
  #   <video>
  #     <source src="<%= video.webm_url %>" type="video/webm">
  #   </video>
  #
  def webm_url
    media.try(:url, :webm) if converted
  end
  
  # === Description
  #
  # Returns the url of the image used anywhere it's necessary the cover of the video with original proportions (it's the middle frame of the video, in 960 x 540 pixels).
  #
  # === Returns
  #
  # An url.
  #
  # === Usage
  #
  #   <%= image_tag video.cover_url %>
  #
  def cover_url
    media.try(:url, :cover) if converted
  end
  
  # === Description
  #
  # Returns the url of the thumb image used in the section "elements" (the middle frame of the video resized to 200 x 200 pixels).
  #
  # === Returns
  #
  # An url.
  #
  # === Usage
  #
  #   <%= image_tag video.thumb_url %>
  #
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
