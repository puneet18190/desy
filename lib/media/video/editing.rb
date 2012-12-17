require 'media'
require 'media/video'
require 'media/video/editing'
require 'shellwords'
require 'env_relative_path'

module Media
  module Video
    module Editing
      
      include EnvRelativePath
      
      AVPROBE_BIN             = CONFIG.avtools.avprobe.cmd.bin
  
      AVCONV_CODECS            = Hash[ FORMATS.map{ |f| [f, CONFIG.avtools.avconv.video.formats.send(f).codecs] } ]
      AVCONV_DEFAULT_BITRATES  = Hash[ FORMATS.map{ |f| [f, CONFIG.avtools.avconv.video.formats.send(f).default_bitrates] } ]
  
      AVCONV_OUTPUT_WIDTH        = CONFIG.avtools.avconv.video.output.width
      AVCONV_OUTPUT_HEIGHT       = CONFIG.avtools.avconv.video.output.height
      AVCONV_OUTPUT_ASPECT_RATIO = Rational(AVCONV_OUTPUT_WIDTH, AVCONV_OUTPUT_HEIGHT)
      AVCONV_OUTPUT_THREADS      = Hash[ FORMATS.map{ |f| [f, CONFIG.avtools.avconv.video.formats.send(f).threads] } ]
      AVCONV_OUTPUT_QA           = Hash[ FORMATS.map{ |f| [f, CONFIG.avtools.avconv.video.formats.send(f).qa] } ]
  
      SOX_BIN            = CONFIG.sox.cmd.bin
      SOX_GLOBAL_OPTIONS = CONFIG.sox.cmd.global_options
  
      IMAGEMAGICK_CONVERT_BIN = CONFIG.imagemagick.convert.cmd.bin
  
      def self.ubuntu_packages
        %w(libav-tools libavcodec-extra-53 mkvtoolnix sox lame)
      end
  
      def self.ubuntu_install
        puts `sudo apt-get install #{ubuntu_packages.map(&:shellescape).join(' ')}`
      end
    end
  end
end

require 'media/video/editing/conversion'
require 'media/video/editing/conversion/job'
require 'media/video/editing/image_to_video'
require 'media/video/editing/concat'
require 'media/video/editing/crop'
require 'media/video/editing/replace_audio'
require 'media/video/editing/transition'
