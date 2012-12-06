require 'recursive_open_struct'

module MediaEditing
  module Video

    CONFIG = RecursiveOpenStruct.new({
      formats: [:webm, :mp4],
      avtools: {
        avprobe: {
          cmd: {
            sh_vars: {},
            bin: 'avprobe'
          },
          subexec_timeout: 10
        },
        avconv: {
          cmd: {
            sh_vars: {},#{ 'LD_LIBRARY_PATH' => '/opt/libav-0.8.4/lib' },
            bin: 'avconv',#/opt/libav-0.8.4/bin/avconv',
            with_filters: {
              sh_vars: {},#{ 'LD_LIBRARY_PATH' => '/opt/libav-0.8.4/lib' },
              bin: 'avconv'#/opt/libav-0.8.4/bin/avconv'
            },
          },
          timeout: 86400,
          formats: {
            webm: { 
              codecs: %w( libvpx libvorbis ),
              threads: 4,
              qa: 5,
              default_bitrates: { video: '2M', audio: '200k' }
            },
            mp4: {
              codecs: %w( libx264 libmp3lame ),
              threads: 'auto',
              qa: 4,
              default_bitrates: { video: nil , audio: '200k' }
            } 
          },
          output: {
            width: 960,
            height: 540
          }
        }
      },
      sox: {
        cmd: {
          bin: 'sox',
          global_options: %w(-V6 --buffer 131072 --multi-threaded)
        }
      },
      imagemagick: {
        convert: {
          cmd: {
            bin: 'convert'
          }
        }
      }
    })

    # AVTOOLS_SH_VARS_ESCAPED = CONFIG.avtools.sh_vars.map{ |k, v| "#{k.to_s.shellescape}=#{v.shellescape}" }.try(:join, ' ').to_s

    # AVPROBE_BIN             = CONFIG.avtools.avprobe.bin
    AVPROBE_SUBEXEC_TIMEOUT = CONFIG.avtools.avprobe.subexec_timeout

    # AVCONV_BIN = '/opt/libav/bin/avconv'
    # AVCONV_BIN             = CONFIG.avtools.avconv.bin
    AVCONV_TIMEOUT         = CONFIG.avtools.avconv.timeout
    AVCONV_SUBEXEC_TIMEOUT = AVCONV_TIMEOUT + 10

    FORMATS                  = CONFIG.formats
    AVCONV_FORMATS           = FORMATS
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
