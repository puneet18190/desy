#
# == Description
#
# Main module of the media managing and editing implementation.
# 
# === Configuration
#
# For details about the configuration, see Media::CONFIG .
#
module Media
  
  # It defines CONFIG
  require 'media/config'

  RAILS_PUBLIC_FOLDER = Rails.root.join 'public'
  TMP_PREFIX          = CONFIG.tmp_prefix

  UBUNTU_REQUIRED_PACKAGES = %w( imagemagick libav-tools libavcodec-extra-53 mkvtoolnix sox )

  def self.ubuntu_install
    exec "sudo apt-get install #{UBUNTU_REQUIRED_PACKAGES.map(&:shellescape).join(' ')}"
  end

end

require 'media/thread'
require 'media/error'
require 'media/in_tmp_dir'
require 'media/info'
require 'media/similar_durations'
require 'media/uploader'
require 'media/video'
require 'media/audio'
