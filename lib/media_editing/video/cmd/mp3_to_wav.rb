require 'media_editing'
require 'media_editing/video'
require 'media_editing/video/cmd'
require 'shellwords'

module MediaEditing
  module Video
    class Cmd
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