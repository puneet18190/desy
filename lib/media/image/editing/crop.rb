require 'media'
require 'media/image'
require 'media/image/editing'
require 'mini_magick'

module Media
  module Image
    module Editing
      class Crop
        
        #input: image
        #output: saving folder
        def initialize(input, output, output_path, x1, y1, x2, y2)
          @input, @output, @output_path, @x1, @y1, @x2, @y2 = input, output, output_path, x1, y1, x2, y2
        end
        
        def run
          w = @x2.to_i - @x1.to_i
          h = @y2.to_i - @y1.to_i
          crop_params = "#{w}x#{h}+#{@x1}+#{@y1}"
          @input.crop(crop_params)
          @input.write File.join(@output.to_s, @output_path)
        end
        
      end
    end
  end
end
