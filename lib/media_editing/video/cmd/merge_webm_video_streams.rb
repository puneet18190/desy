require 'media_editing'
require 'media_editing/video'
require 'media_editing/video/cmd'
require 'shellwords'

module MediaEditing
  module Video
    class Cmd
      class MergeWebmVideoStreams < MediaEditing::Video::Cmd

        def initialize(inputs, output)
          @inputs, @output = inputs, output
        end

        private
        def cmd!
          inputs = @inputs.map{ |input| "--no-audio #{input.shellescape}" }.join(' + ')
          output = @output.shellescape
          "mkvmerge -o #{output} --verbose #{inputs}"
        end

      end
    end
  end
end