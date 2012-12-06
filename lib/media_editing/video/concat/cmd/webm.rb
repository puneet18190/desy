require 'media_editing/video/concat/cmd'
require 'shellwords'

module MediaEditing
  module Video
    class Concat
      module Cmd

        class Webm < MediaEditing::Video::Cmd::Avconv
          def initialize(video_input, audio_input, _duration, output)
            @video_input, @audio_input, @duration, @output = video_input, audio_input, _duration, output
            inputs = [@video_input]
            inputs << @audio_input if @audio_input
            super inputs, @output, :webm
            output_options [ vcodec, acodec, duration, shortest ]
          end

          private
          def duration
            "-t #{@duration.round(2).to_s.shellescape}"
          end

          def vcodec
            '-c:v copy'
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
