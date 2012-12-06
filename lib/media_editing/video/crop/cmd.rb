require 'media_editing/video'
require 'media_editing/video/crop'
require 'media_editing/video/cmd/avconv'

module MediaEditing
  module Video
    class Crop
      class Cmd < MediaEditing::Video::Cmd::Avconv
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