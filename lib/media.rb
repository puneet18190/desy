module Media
  
  # Definisce CONFIG
  require 'media/config'

  TMP_PREFIX = CONFIG.tmp_prefix
end

require 'media/error'
require 'media/in_tmp_dir'
require 'media/info'
require 'media/allowed_duration_range'
require 'media/video'
require 'media/audio'
