require 'media_editing'
require 'shellwords'
require 'env_relative_path'

module MediaEditing
  module Video
    
    include EnvRelativePath
    
    FORMATS = MediaEditing::CONFIG.avtools.avconv.video.formats.marshal_dump.keys

    AVPROBE_BIN             = CONFIG.avtools.avprobe.cmd.bin
    AVPROBE_SUBEXEC_TIMEOUT = CONFIG.avtools.avprobe.cmd.subexec_timeout

    AVCONV_BIN             = CONFIG.avtools.avconv.cmd.bin
    AVCONV_TIMEOUT         = CONFIG.avtools.avconv.cmd.timeout
    AVCONV_SUBEXEC_TIMEOUT = AVCONV_TIMEOUT + 10

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

require 'media_editing/video/conversion'
require 'media_editing/video/conversion/job'
require 'media_editing/video/image_to_video'
require 'media_editing/video/concat'
require 'media_editing/video/crop'
require 'media_editing/video/replace_audio'
require 'media_editing/video/transition'
