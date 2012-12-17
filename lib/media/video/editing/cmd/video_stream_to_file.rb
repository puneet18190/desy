require 'media/video/editing'
require 'media/video/editing'
require 'media/video/editing/cmd'
require 'media/video/editing/cmd/avconv'
require 'shellwords'

module Media
  module Video
    module Editing
      class Cmd
        class VideoStreamToFile < Cmd::Avconv
          def initialize(input, output)
            @input, @output = input, output
          end
  
          private
          def cmd!
            %Q[ #{self.class.bin}
                  #{global_options.join(' ')}
                  -i #{@input.shellescape}
                  -map 0:v:0
                  -c copy
                  #{@output.shellescape} ].squish
          end
        end
      end
    end
  end
end
