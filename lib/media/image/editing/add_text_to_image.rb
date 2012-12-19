require 'media'
require 'media/image'
require 'media/image/editing'
require 'mini_magick'

module Media
  module Image
    module Editing
      class AddTextToImage
        
        def initialize(img, color_hex, font_size, coords_value, text_value)
          @img, @color_hex, @font_size, @coords_value, @text_value = img, color_hex, font_size, coords_value, text_value
        end
        
        def run
          @img.combine_options do |c|
            c.fill "#{@color_hex}"
            c.stroke "none"
            #c.encoding = "Unicode"
            c.font "#{Rails.root.join('vendor/fonts/DroidSansFallback.ttf')}"
            size_value = params["font_#{t_num}"].to_f * 0.75
            width_val = woh[1]
            original_val = woh[0]
            c.pointsize "#{ratio_value(width_val,(size_value), original_val)}"
            c.gravity 'NorthWest'
            coords_value = params["coords_#{t_num}"].to_s.split(",")
            c0 = ratio_value(width_val,coords_value[0], original_val)
            c1 = ratio_value(width_val,coords_value[1], original_val)
            text_value = params["text_#{t_num}"]

            c.draw "text #{c0},#{c1} '#{text_value.shellescape}'"
          end
        end
        
      end
    end
  end
end