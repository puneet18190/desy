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

  def self.ubuntu_packages
    %w( libav-tools libavcodec-extra-53 mkvtoolnix sox )
  end
  
  def self.ubuntu_install
    puts `sudo apt-get install #{ubuntu_packages.map(&:shellescape).join(' ')} 2>&1`
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
