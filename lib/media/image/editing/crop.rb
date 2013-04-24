require 'media'
require 'media/image'
require 'media/image/editing'
require 'mini_magick'

module Media
  module Image
    module Editing
      # Class containing methods to crop an image
      class Crop
        
        # Initializes the crop
        def initialize(input, output, x1, y1, x2, y2)
          @input, @output, @x1, @y1, @x2, @y2 = input, output, x1, y1, x2, y2
        end
        
        # Runs the crop
        def run
          w = @x2.to_i - @x1.to_i
          h = @y2.to_i - @y1.to_i
          crop_params = "#{w}x#{h}+#{@x1}+#{@y1}"
          @input.crop(crop_params)
          @input.write @output
        end
        
      end
    end
  end
end
