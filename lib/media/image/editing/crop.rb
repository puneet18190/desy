require 'media'
require 'media/image'
require 'media/image/editing'
require 'mini_magick'

module Media
  module Image
    module Editing
      class Crop
        
        def initialize(input, output, x1, y1, x2, y2)
          #input: image
          #output: saving folder
          @input, @output, @x1, @y1, @x2, @y2  = input, output, x1, y1, x2, y2
        end
        
        def run
          w = @x2.to_i - @x1.to_i
          h = @y2.to_i - @y1.to_i
          crop_params = "#{w}x#{h}+#{@x1}+#{@y1}"
          @input.crop(crop_params)
          custom_filename = "tmp_#{Time.now.strftime('%Y%m%d-%H%M%S')}.jpg"
          @input.write("#{@output}/"+custom_filename)
          return custom_filename
        end
        
      end
    end
  end
end