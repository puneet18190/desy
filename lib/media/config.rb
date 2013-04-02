require 'media'
require 'recursive_open_struct'

module Media

  #
  # See Media section: configuration for details about the configuration.
  #
  CONFIG = RecursiveOpenStruct.new({
    tmp_prefix: "desy#{::Thread.current.object_id}",
    avtools: {
      avprobe: {
        cmd: {
          sh_vars: {},
          bin: 'avprobe',
          subexec_timeout: 10
        }
      },
      avconv: {
        cmd: {
          sh_vars: {},
          bin: 'avconv',
          timeout: 86400
        },
        video: {
          formats: {
            mp4: {
              codecs: %w( libx264 libmp3lame ),
              threads: 'auto',
              qa: 4,
              default_bitrates: { video: nil , audio: '200k' }
            },
            webm: { 
              codecs: %w( libvpx libvorbis ),
              threads: 4,
              qa: 5,
              default_bitrates: { video: '2M', audio: '200k' }
            }
          },
          output: {
            width: 960,
            height: 540
          }
        },
        audio: {
          formats: {
            mp3: {
              codecs: [nil, 'libmp3lame'],
              threads: 'auto',
              qa: 4,
              default_bitrates: { video: nil, audio: '200k' }
            },
            ogg: { 
              codecs: [nil, 'libvorbis'],
              threads: 4,
              qa: 5,
              default_bitrates: { video: nil, audio: '200k' }
            }
          }
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
    },
    video: {
      cover_format: 'cover_%s.jpg',
      thumb_format: 'thumb_%s.jpg',
      thumb_sizes:  [200, 200]
    },
    duration_threshold: 1
  })

end