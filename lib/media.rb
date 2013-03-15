module Media
  
  # Definisce CONFIG
  require 'media/config'

  RAILS_PUBLIC_FOLDER = Rails.root.join 'public'
  TMP_PREFIX          = CONFIG.tmp_prefix

  DATABASE_POOL       = Rails.configuration.database_configuration[Rails.env]['pool']


  def self.ubuntu_packages
    # XXX postgresql-contrib-9.2 non dovrebbe stare qui!!!
    %w(libav-tools libavcodec-extra-53 mkvtoolnix sox lame postgresql-contrib-9.2)
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
