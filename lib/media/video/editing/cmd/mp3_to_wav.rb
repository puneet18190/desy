require 'media_editing'
require 'media/video/editing'
require 'media/video/editing/cmd'
require 'shellwords'

module MediaEditing
  module Video
    class Cmd
      class Mp3ToWav < Cmd

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