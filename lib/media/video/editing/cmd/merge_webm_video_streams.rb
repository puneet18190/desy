require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/video/editing/cmd'
require 'shellwords'

module Media
  module Video
    module Editing
      class Cmd
        class MergeWebmVideoStreams < Cmd
  
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
