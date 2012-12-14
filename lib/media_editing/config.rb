require 'media_editing'
require 'recursive_open_struct'

module MediaEditing

  CONFIG = RecursiveOpenStruct.new({
    tmp_prefix: "desy#{Thread.current.object_id}",
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
      duration_threshold: 1
    }
  })

end