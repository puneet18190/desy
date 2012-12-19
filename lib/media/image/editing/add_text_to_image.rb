require 'media'
require 'media/image'
require 'media/image/editing'
require 'mini_magick'

module Media
  module Image
    module Editing
      class AddTextToImage
        
        #img is a mini_magick object
        def initialize(img, color_hex, font_size, coordX, coordY, text_value)
          @img, @color_hex, @font_size, @coordX, @coordY, @text = img, color_hex, font_size, coordX, coordY, text_value
        end
        
        def run
          @img.combine_options do |c|
            c.fill "#{@color_hex}"
            c.stroke "none"
            c.font "#{Rails.root.join('vendor/fonts/DroidSansFallback.ttf')}"
            c.pointsize "#{@font_size}"
            c.gravity 'NorthWest'
            #c.annotate
            c.draw "text #{@coordX.to_i},#{@coordY.to_i} #{shellescaped_text}"
          end
        end
        
        private
        def shellescaped_text
          case @text
          when File, Tempfile
            "@#{text.path.shellescape}"
          when Pathname
            "@#{text.to_s.shellescape}"
          else
            @text.to_s.shellescape
          end
        end
        
      end
    end
  end
end