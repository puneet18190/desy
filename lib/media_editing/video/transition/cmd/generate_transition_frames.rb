require 'media_editing/video'
require 'media_editing/video/transition'
require 'media_editing/video/transition/cmd'
require 'media_editing/video/cmd'
require 'shellwords'

module MediaEditing
  module Video
    class Transition
      class Cmd
        class GenerateTransitionFrames < MediaEditing::Video::Cmd

          BIN = MediaEditing::Video::IMAGEMAGICK_CONVERT_BIN.shellescape

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
end