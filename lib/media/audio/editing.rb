require 'media'
require 'media/audio'
require 'recursive_open_struct'
require 'env_relative_path'

module Media
  module Audio
    module Editing
      SOX_BIN            = CONFIG.sox.cmd.bin
      SOX_GLOBAL_OPTIONS = CONFIG.sox.cmd.global_options

      AVCONV_CODECS         = Hash[ FORMATS.map{ |f| [f, CONFIG.avtools.avconv.audio.formats.send(f).codecs] } ]
      AVCONV_OUTPUT_THREADS = Hash[ FORMATS.map{ |f| [f, CONFIG.avtools.avconv.audio.formats.send(f).threads] } ]
      AVCONV_OUTPUT_QA      = Hash[ FORMATS.map{ |f| [f, CONFIG.avtools.avconv.audio.formats.send(f).qa] } ]
    end
  end
end

require 'media/audio/editing/concat'
require 'media/audio/editing/crop'
require 'media/audio/editing/conversion'
require 'media/audio/editing/conversion/job'
require 'media/audio/editing/composer'
require 'media/audio/editing/composer/job'