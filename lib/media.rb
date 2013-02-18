module Media
  
  # Definisce CONFIG
  require 'media/config'

  RAILS_PUBLIC_FOLDER = Rails.root.join 'public'
  TMP_PREFIX          = CONFIG.tmp_prefix

  def self.ubuntu_packages
    # XXX postgresql-contrib-9.2 non dovrebbe stare qui!!!
    %w(libav-tools libavcodec-extra-53 mkvtoolnix sox lame postgresql-contrib-9.2)
  end
  
  def self.ubuntu_install
    puts `sudo apt-get install #{ubuntu_packages.map(&:shellescape).join(' ')} 2>&1`
  end
end

require 'media/error'
require 'media/in_tmp_dir'
require 'media/info'
require 'media/allowed_duration_range'
require 'media/uploader'
require 'media/video'
require 'media/audio'
