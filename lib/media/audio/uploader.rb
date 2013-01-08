require 'media'
require 'media/audio'
require 'media/uploader'
require 'media/allowed_duration_range'
require 'media/audio/editing/conversion/job'

module Media
  module Audio
    class Uploader < Uploader

      require 'media/audio/uploader/validation'

      include Validation

      self.public_relative_folder        = env_relative_path 'media_elements/audios'
      self.absolute_folder               = File.join RAILS_PUBLIC, public_relative_folder
      self.extension_white_list          = %w(mp3 ogg flac aiff wav wma aac)
      self.extension_white_list_with_dot = extension_white_list.map{ |ext| ".#{ext}" }
      self.min_duration                  = 1
      self.duration_threshold            = CONFIG.audio.duration_threshold
      self.formats                       = FORMATS
      self.allowed_keys                  = [:filename] + formats
      self.version_formats               = VERSION_FORMATS
      self.conversion_class              = Editing::Conversion

    end
  end
end
