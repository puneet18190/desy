require 'media_editing'
require 'media/video/editing'
require 'media/video/editing/cmd'
require 'shellwords'

module MediaEditing
  module Video
    class Cmd
      class GenerateTransitionFrames < Cmd

        BIN = IMAGEMAGICK_CONVERT_BIN.shellescape

        # convert arbitro.jpg piscina.jpg -morph 23 trans.jpg
        def initialize(start_frame, end_frame, frames_format, frames_amount)
          @start_frame, @end_frame, @frames_format, @frames_amount = start_frame, end_frame, frames_format, frames_amount
        end

        private
        def cmd!
          "#{BIN} #{start_frame} #{end_frame} -morph #{frames_amount} #{frames_format}"
        end

        def start_frame
          @start_frame.shellescape
        end

        def end_frame
          @end_frame.shellescape
        end

        def frames_amount
          @frames_amount.to_s.shellescape
        end

        def frames_format
          @frames_format.shellescape
        end

      end
    end
  end
end