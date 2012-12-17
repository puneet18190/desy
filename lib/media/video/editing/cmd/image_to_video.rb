require 'media_editing'
require 'media/video/editing'
require 'media/video/editing/cmd'
require 'media/video/editing/cmd/avconv'
require 'shellwords'

module MediaEditing
  module Video
    class Cmd
      class ImageToVideo < Cmd::Avconv
        def initialize(input_file, output_file, format, duration)
          super([input_file], output_file, format)

          input_options  [ '-loop 1' ]
          output_options [ vcodec, "-t #{duration.round(2).to_s.shellescape}" ]
        end

        private
        def qa
          nil
        end
      end
    end
  end
end