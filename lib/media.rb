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

  # The folder where are located the static files
  RAILS_PUBLIC_FOLDER = Pathname.new Rails.public_path
  # The prefix of the temporary files created by the media processings
  TMP_PREFIX          = CONFIG.tmp_prefix

end

require 'media/thread'
require 'media/error'
require 'media/in_tmp_dir'
require 'media/info'
require 'media/similar_durations'
require 'media/uploader'
require 'media/video'
require 'media/audio'
