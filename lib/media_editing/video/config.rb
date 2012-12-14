require 'recursive_open_struct'

module MediaEditing
  module Video

    CONFIG = RecursiveOpenStruct.new({
      formats: [:mp4, :webm],
      duration_threshold: 1,
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
            sh_vars: {},#{ 'LD_LIBRARY_PATH' => '/opt/libav-0.8.4/lib' },
            bin: 'avconv',#/opt/libav-0.8.4/bin/avconv',
            with_filters: {
              sh_vars: {},#{ 'LD_LIBRARY_PATH' => '/opt/libav-0.8.4/lib' },
              bin: 'avconv'#/opt/libav-0.8.4/bin/avconv'
            },
            timeout: 86400
          },
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

  end
end