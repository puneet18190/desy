require 'media_editing'
require 'media_editing/video'
require 'media_editing/video/cmd'
require 'media_editing/video/cmd/avconv'
require 'shellwords'

module MediaEditing
  module Video
    class Cmd
      class Transition < MediaEditing::Video::Cmd::Avconv

        # avconv -r 25 -i ../trans-%d.jpg -c:v libx264 -q 1  trans.r25.mp4
        def initialize(transitions, output, _frame_rate, format)
          @transitions, @output, @frame_rate, @format = transitions, output, _frame_rate, format
          super [@transitions], @output, format
          input_options  [ frame_rate ]
          output_options [ vcodec ]
        end

        private
        def frame_rate
          "-r #{@frame_rate.to_s.shellescape}"
        end

        def qa
        end

      end
    end
  end
end