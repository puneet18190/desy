#
# == Description
#
# Main module of the media elements management, processing and editing implementation.
# 
# == Configuration
#
# For details about the configuration, see Media::CONFIG .
#
module Media
  
  # It defines CONFIG
  require 'media/config'

  # MIME types of the generated media
  MIME_TYPES = { '.jpg'  => 'image/jpeg' ,
                 '.jpeg' => 'image/jpeg' ,
                 '.png'  => 'image/png'  ,
                 '.mp4'  => 'video/mp4'  ,
                 '.webm' => 'video/webm' ,
                 '.m4a'  => 'audio/mp4'  ,
                 '.ogg'  => 'audio/ogg'  }

end

require 'media/thread'
require 'media/error'
require 'media/in_tmp_dir'
require 'media/info'
require 'media/similar_durations'
require 'media/uploader'
require 'media/video'
require 'media/audio'
