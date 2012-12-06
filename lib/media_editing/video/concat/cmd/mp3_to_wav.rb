require 'media_editing/video/concat/cmd'

module MediaEditing
  module Video
    class Concat
      module Cmd

        class Mp3ToWav < MediaEditing::Video::Cmd

          LAME_BIN = 'lame'

          def initialize(input, output)
            @input, @output = input, output
          end

          def cmd!
            "#{LAME_BIN.shellescape} --verbose #{@input.shellescape} --decode #{@output.shellescape}"
          end

        end

      end
    end
  end
end