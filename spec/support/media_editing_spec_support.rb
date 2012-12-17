require 'media'

module MediaEditingSpecSupport
  SAMPLES_FOLDER = Pathname.new File.expand_path('../samples', __FILE__)

  INVALID_VIDEO             = SAMPLES_FOLDER.join('invalid video.flv').to_s
  VALID_VIDEO               = SAMPLES_FOLDER.join('valid video.flv').to_s
  VALID_VIDEO_WITH_ODD_SIZE = SAMPLES_FOLDER.join('valid video with odd size.webm').to_s
  VALID_JPG                 = SAMPLES_FOLDER.join('valid image.jpg').to_s
  VALID_PNG                 = SAMPLES_FOLDER.join('valid image.png').to_s
  #INVALID_IMAGE             = SAMPLES_FOLDER.join 'invalid image.jpg'
  
  CROP_VIDEOS = { mp4: SAMPLES_FOLDER.join('con verted.mp4').to_s, webm: SAMPLES_FOLDER.join('con verted.webm').to_s }
  
  CONCAT_VIDEOS = {
                    videos_with_some_audio_streams: {
                      videos: Hash[ [:mp4, :webm].map{ |f| [f, (['concat 1', 'concat 2'] * 2).map{ |v| SAMPLES_FOLDER.join("#{v}.#{f}").to_s } ] } ],
                      output_infos: {
                        mp4:  {:duration=>96.36, :streams=>{:video=>[{:codec=>"h264", :width=>960, :height=>540, :bitrate=>865}], :audio=>[{:codec=>"mp3", :bitrate=>69}]}},
                        webm: {:duration=>96.34, :streams=>{:video=>[{:codec=>"vp8", :width=>960, :height=>540, :bitrate=>nil}], :audio=>[{:codec=>"vorbis", :bitrate=>nil}]}}
                      }
                    },
                    videos_without_audio_streams:   { 
                      videos: Hash[ [:mp4, :webm].map{ |f| [f, (['concat 1'] * 2).map{ |v| SAMPLES_FOLDER.join("#{v}.#{f}").to_s } ] } ],
                      output_infos: {
                        mp4:  {:duration=>20.0, :streams=>{:video=>[{:codec=>"h264", :width=>960, :height=>540, :bitrate=>56}], :audio=>[]}},
                        webm: {:duration=>20.0, :streams=>{:video=>[{:codec=>"vp8", :width=>960, :height=>540, :bitrate=>nil}], :audio=>[]}}
                      }
                    }
                  }

  REPLACE_AUDIO_VIDEOS = { 
                           videos_with_some_audio_streams: {
                             video_inputs: Hash[ [:mp4, :webm].map{ |f| [f, SAMPLES_FOLDER.join("con verted.#{f}").to_s] } ],
                             audio_inputs: Hash[ [:mp3, :ogg ].map{ |f| [f, SAMPLES_FOLDER.join("valid audio.#{f}").to_s] } ]
                           },
                           videos_without_audio_streams:   { 
                             video_inputs: Hash[ [:mp4, :webm].map{ |f| [f, SAMPLES_FOLDER.join("converted no audio.#{f}").to_s] } ],
                             audio_inputs: Hash[ [:mp3, :ogg ].map{ |f| [f, SAMPLES_FOLDER.join("valid audio.#{f}").to_s] } ]
                           }
                         }

  TRANSITION_VIDEOS = {
    start_inputs: Hash[ [:mp4, :webm].map{ |f| [f, SAMPLES_FOLDER.join("con verted.#{f}").to_s] } ],
    end_inputs:   Hash[ [:mp4, :webm].map{ |f| [f, SAMPLES_FOLDER.join("converted no audio.#{f}").to_s] } ]
  }

  FORMATS = [:webm, :mp4]
  AVCONV_SH_VARS                      = {}#{ 'LD_LIBRARY_PATH' => '/opt/libav-0.8.4/lib' }
  AVCONV_WITH_FILTERS_SH_VARS         = AVCONV_SH_VARS#{ 'LD_LIBRARY_PATH' => '/opt/libav-0.8.4/lib' }
  AVCONV_PRE_COMMAND                  = 'avconv -v 9 -loglevel 99 -benchmark -y -timelimit 86400'#/opt/libav-0.8.4/bin/avconv'
  AVCONV_WITH_FILTERS_PRE_COMMAND     = AVCONV_PRE_COMMAND#'/opt/libav-0.8.4/bin/avconv'
  AVCONV_WITH_FILTERS_SUBEXEC_OPTIONS = { sh_vars: AVCONV_SH_VARS, timeout: 86410 }
  VBITRATE                  = { mp4: '', webm: ' -b:v 2M' }

  AVPROBE_PRE_COMMAND     = 'avprobe'
  AVPROBE_SH_VARS         = AVCONV_SH_VARS
  AVPROBE_SUBEXEC_SH_VARS = {"LANG"=>"C"}
  AVPROBE_SUBEXEC_TIMEOUT = 10
  AVPROBE_SUBEXEC_OPTIONS = { sh_vars: AVPROBE_SH_VARS, timeout: AVPROBE_SUBEXEC_TIMEOUT }

  IMAGEMAGICK_CONVERT_PRE_COMMAND = 'convert'
end

MESS = MediaEditingSpecSupport