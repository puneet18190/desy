require 'media_editing/video/config'

module MediaEditing
  module Video
    FORMATS = CONFIG.formats

    AVPROBE_BIN             = CONFIG.avtools.avprobe.cmd.bin
    AVPROBE_SUBEXEC_TIMEOUT = CONFIG.avtools.avprobe.cmd.subexec_timeout

    AVCONV_BIN             = CONFIG.avtools.avconv.cmd.bin
    AVCONV_TIMEOUT         = CONFIG.avtools.avconv.cmd.timeout
    AVCONV_SUBEXEC_TIMEOUT = AVCONV_TIMEOUT + 10

    # AVCONV_FORMATS           = FORMATS
    AVCONV_CODECS            = Hash[ AVCONV_FORMATS.map{ |f| [f, CONFIG.avtools.avconv.formats.send(f).codecs] } ]
    AVCONV_DEFAULT_BITRATES  = Hash[ AVCONV_FORMATS.map{ |f| [f, CONFIG.avtools.avconv.formats.send(f).default_bitrates] } ]

    AVCONV_OUTPUT_WIDTH        = CONFIG.avtools.avconv.output.width
    AVCONV_OUTPUT_HEIGHT       = CONFIG.avtools.avconv.output.height
    AVCONV_OUTPUT_ASPECT_RATIO = Rational(AVCONV_OUTPUT_WIDTH, AVCONV_OUTPUT_HEIGHT)
    AVCONV_OUTPUT_THREADS      = Hash[ AVCONV_FORMATS.map{ |f| [f, CONFIG.avtools.avconv.formats.send(f).threads] } ]
    AVCONV_OUTPUT_QA           = Hash[ AVCONV_FORMATS.map{ |f| [f, CONFIG.avtools.avconv.formats.send(f).qa] } ]

    SOX_BIN            = CONFIG.sox.cmd.bin
    SOX_GLOBAL_OPTIONS = CONFIG.sox.cmd.global_options

    IMAGEMAGICK_CONVERT_BIN = CONFIG.imagemagick.convert.cmd.bin

    TMP_PREFIX = "desy.#{Thread.current.object_id}"
  end
end

require 'media_editing/video/conversion'
require 'media_editing/video/conversion/job'
require 'media_editing/video/image_to_video'
require 'media_editing/video/concat'
require 'media_editing/video/crop'
require 'media_editing/video/replace_audio'
require 'media_editing/video/transition'
