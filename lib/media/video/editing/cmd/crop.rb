require 'media_editing'
require 'media/video/editing'
require 'media/video/editing/cmd'
require 'media/video/editing/cmd/avconv'
require 'shellwords'

module MediaEditing
  module Video
    class Cmd
      class Crop < Cmd::Avconv
        def initialize(input, output, _start, _duration, format)
          inputs = [input]
          super inputs, output, format
          @start, @duration = _start, _duration
          output_options [ vcodec, acodec, start, duration ]
        end

        private
        def start
          "-ss #{@start.round(2).to_s.shellescape}"
        end
        def duration
          "-t #{@duration.round(2).to_s.shellescape}"
        end
      end
    end
  end
end