require 'media_editing/video'
require 'media_editing/video/transition'
require 'media_editing/video/transition/cmd'
require 'media_editing/video/cmd/avconv'
require 'shellwords'

module MediaEditing
  module Video
    class Transition
      class Cmd
        class ExtractFrame < MediaEditing::Video::Cmd::Avconv

          # avconv -i arbitro.webm -ss 38.70 -frames:v 1 arbitro.jpg
          def initialize(input, output, _seek)
            @input, @output, @seek = input, output, _seek
            super [@input], @output
            output_options [ seek, vframes ]
          end

          private
          def seek
            "-ss #{@seek.to_s.shellescape}"
          end

          def vframes
            "-frames:v 1"
          end

          def qv
          end

          def sn
          end

        end
      end
    end
  end
end