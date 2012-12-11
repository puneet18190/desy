require 'media_editing'
require 'media_editing/video'
require 'media_editing/video/cmd'
require 'media_editing/video/cmd/avconv'
require 'shellwords'

module MediaEditing
  module Video
    class Cmd
      class ReplaceAudio < MediaEditing::Video::Cmd::Avconv

        def initialize(video_input, audio_input, _duration, output, format)
          @video_input, @audio_input, @duration, @output = video_input, audio_input, _duration, output
          inputs = [@video_input, @audio_input]
          super inputs, @output, format
          output_options [ maps, vcodec, acodec, qa, duration ]
        end

        private
        def duration
          "-t #{@duration.round(2).to_s.shellescape}"
        end

        def maps
          '-map 0:v:0 -map 1:a:0'
        end

        def vcodec
          '-c:v copy'
        end

        def acodec
          if @format == :webm
            '-c:a libvorbis'
          else
            '-c:a copy'
          end
        end

        def qa
          super if @format == :webm
        end

      end
    end
  end
end