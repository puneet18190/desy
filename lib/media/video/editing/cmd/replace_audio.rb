require 'media/video/editing'
require 'media/video/editing'
require 'media/video/editing/cmd'
require 'media/video/editing/cmd/avconv'
require 'shellwords'

module Media
  module Video
    module Editing
      class Cmd
        class ReplaceAudio < Cmd::Avconv
  
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
end
