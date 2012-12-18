require 'media'
require 'media/image'
require 'media/image/editing'
require 'mini_magick'

module Media
  module Image
    module Editing
      class TextToImage < Cmd

        attr_reader :output, :text, :width, :height, :text_color, :background_color, :font, :gravity, :pointsize

        def initialize(output, text, options = {})
          @output, @text = output, text

          @width            = options[:width]            || 960
          @height           = options[:height]           || 540
          @text_color       = options[:text_color]       || 'black'
          @background_color = options[:background_color] || 'white'
          @font             = options[:font]             || Rails.root.join('vendor/fonts/DroidSansFallback.ttf')
          @gravity          = options[:gravity]          || 'Center'
          @pointsize        = options[:pointsize]        || 48
        end

        private
        def text
          case @text
          when File, Tempfile
            "@#{text.path.shellescape}"
          when Pathname
            "@#{text.to_s.shellescape}"
          else
            @text.to_s.shellescape
          end
        end

        def cmd!
          %Q[ convert
                -size       #{width.to_s.shellescape}x#{height.to_s.shellescape}
                -background #{background_color.to_s.shellescape}
                -fill       #{text_color.to_s.shellescape}
                -font       #{font.to_s.shellescape}
                -pointsize  #{pointsize.to_s.shellescape}
                -gravity    #{gravity.to_s.shellescape}
                label:#{text}
                #{output.shellescape} ].squish
        end

      end
    end
  end
end