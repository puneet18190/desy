require 'media_editing'
require 'media/video/editing'
require 'media/video/editing/cmd'
require 'media/video/editing/cmd/concat'
require 'media/video/editing/cmd/avconv'
require 'shellwords'

module MediaEditing
  module Video
    class Cmd
      module Concat

        class Mp4 < Cmd::Avconv
          def initialize(video_input, audio_input, _duration, output)
            @video_input, @audio_input, @duration, @output = video_input, audio_input, _duration, output
            inputs = [@video_input]
            inputs << @audio_input if @audio_input
            super inputs, @output, :mp4
            output_options [ vcodec, acodec, duration, shortest ]
          end

          private
          def duration
            "-t #{@duration.round(2).to_s.shellescape}"
          end

          def acodec
            super if @audio_input
          end

          def shortest
            '-shortest'
          end
        end

      end
    end
  end
end
