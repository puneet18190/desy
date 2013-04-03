require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/in_tmp_dir'
require 'media/image/editing/cmd/text_to_image'

module Media
  module Video
    module Editing
      class TextToVideo
  
        include InTmpDir

        TEXT_TO_IMAGE_OPTIONS = Image::Editing::Cmd::TextToImage::OPTIONS

        attr_reader :text, :duration, *TEXT_TO_IMAGE_OPTIONS
  
        def initialize(text, output_without_extension, duration, options = {}, log_folder = nil)
          unless output_without_extension.is_a?(String)
            raise Error.new('output_without_extension must be a String', output_without_extension: output_without_extension)
          end
  
          unless duration.is_a?(Numeric) and duration > 0
            raise Error.new('duration must be a Numeric > 0', duration: duration)
          end
  
          @text, @output_without_extension, @duration, @options = text, output_without_extension, duration, options

          @log_folder = log_folder
        end
  
        def run
          outputs = nil
  
          in_tmp_dir do
            image = tmp_path 'text_to_image.jpg'
            Image::Editing::Cmd::TextToImage.new(text, image, @options).run!

            outputs = ImageToVideo.new(image, @output_without_extension, duration, @log_folder).run
          end

          outputs
        end

      end
    end
  end
end
