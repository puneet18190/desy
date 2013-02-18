require 'media'
require 'media/audio'
require 'media/uploader'
require 'media/allowed_duration_range'
require 'media/audio/editing/conversion/job'
require 'env_relative_path'

module Media
  module Audio
    class Uploader < Uploader

      require 'media/audio/uploader/validation'

      include Validation
      include EnvRelativePath

      PUBLIC_RELATIVE_FOLDER        = env_relative_path File.join(PUBLIC_RELATIVE_MEDIA_ELEMENTS_FOLDER, 'audios')
      FOLDER                        = File.join RAILS_PUBLIC_FOLDER, PUBLIC_RELATIVE_FOLDER
      EXTENSION_WHITE_LIST          = %w(mp3 ogg flac aiff wav wma aac)
      EXTENSION_WHITE_LIST_WITH_DOT = EXTENSION_WHITE_LIST.map{ |ext| ".#{ext}" }
      MIN_DURATION                  = 1
      DURATION_THRESHOLD            = CONFIG.audio.duration_threshold
      FORMATS                       = FORMATS
      ALLOWED_KEYS                  = [:filename] + FORMATS
      VERSION_FORMATS               = VERSION_FORMATS
      CONVERSION_CLASS              = Editing::Conversion

    end
  end
end
