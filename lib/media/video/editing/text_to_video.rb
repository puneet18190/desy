require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/logging'
require 'media/in_tmp_dir'
require 'media/image/editing/cmd/text_to_image'

module Media
  module Video
    module Editing
      class TextToVideo
  
        include Logging
        include InTmpDir

        TEXT_TO_IMAGE_OPTIONS = Image::Editing::Cmd::TextToImage::OPTIONS

        attr_reader :text, :duration, *TEXT_TO_IMAGE_OPTIONS
  
        def initialize(text, output_without_extension, duration, options = {})
          unless output_without_extension.is_a?(String)
            raise Error.new('output_without_extension must be a String', output_without_extension: output_without_extension)
          end
  
          unless duration.is_a?(Numeric) and duration > 0
            raise Error.new('duration must be a Numeric > 0', duration: duration)
          end
  
          @text, @output_without_extension, @duration, @options = text, output_without_extension, duration, options
        end
  
        def run
          create_log_folder
  
          in_tmp_dir do
            image = tmp_path 'text_to_image.jpg'
            Image::Editing::Cmd::TextToImage.new(text, image, options).run!

            ImageToVideo.new(image, outputs, duration).run
          end

          outputs
        end
  
        private
        def output(format)
          "#{@output_without_extension}.#{format}"
        end
  
        def outputs
          Hash[ FORMATS.map{ |format| [format, output(format)] } ]
        end

      end
    end
  end
end
