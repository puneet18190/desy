require 'media_editing/video/concat/cmd'

module MediaEditing
  module Video
    class Concat
      module Cmd

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
end