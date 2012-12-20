require 'media'
require 'media/image'
require 'media/image/editing'
require 'media/image/editing/cmd'

module Media
  module Image
    module Editing
      class AddTextToImage < Cmd
        
        #img is a mini_magick object
        def initialize(img, color_hex, font_size, coordX, coordY, text_value)
          @img, @color_hex, @font_size, @coordX, @coordY, @text = img, color_hex, font_size, coordX, coordY, text_value
        end
        
        private
        
        def cmd!
        font = "#{Rails.root.join('vendor/fonts/DroidSansFallback.ttf')}"
        %Q[ mogrify
              -fill       #{@color_hex.to_s.shellescape}
              -stroke     none
              -font       #{font.to_s.shellescape}
              -pointsize  #{@font_size.to_s.shellescape}
              -gravity    NorthWest
              -annotate   +#{@coordX.to_i.to_s.shellescape}+#{@coordY.to_i.to_s.shellescape} #{shellescaped_text}
              #{@img.to_s.shellescape} ].squish
        end
        
        def shellescaped_text
          case @text
          when File, Tempfile
            "@#{@text.path.shellescape}"
          when Pathname
            "@#{@text.to_s.shellescape}"
          else
            @text.to_s.shellescape
          end
        end
        
      end
    end
  end
end