require 'media_editing/video/concat/cmd'

module MediaEditing
  module Video
    class Concat
      module Cmd

        class AudioStreamToFile < MediaEditing::Video::Cmd::Avconv
          def initialize(input, output)
            @input, @output = input, output
          end

          private
          def cmd!
            %Q[ #{self.class.bin}
                  #{global_options.join(' ')}
                  -i #{@input.shellescape}
                  -map 0:a:0
                  -c copy
                  #{@output.shellescape} ].squish
          end
        end

      end
    end
  end
end