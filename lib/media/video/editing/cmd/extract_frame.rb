require 'media/video/editing'
require 'media/video/editing'
require 'media/video/editing/cmd'
require 'media/video/editing/cmd/avconv'
require 'shellwords'

module Media
  module Video
    module Editing
      class Cmd
        class ExtractFrame < Cmd::Avconv
  
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
