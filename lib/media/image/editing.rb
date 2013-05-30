require 'media'
require 'media/image'

module Media
  module Image
    # Module containing logics for image editing
    module Editing

      # Ratio X
      RATIO_X = 660

      # Ratio Y
      RATIO_Y = 500

      # === Description
      #
      # Returns the original value of a coordinate, given the actual value and the size of the image
      #
      # === Arguments
      #
      # * *w*: width of the image
      # * *h*: height of the image
      # * *value*: value to be scaled
      #
      # === Returns
      #
      # A float.
      #
      def self.ratio_value(w, h, value)
        w, h = w.to_f, h.to_f

        to_ratio = RATIO_X / RATIO_Y
        origin_ratio = w / h

        w =
          if origin_ratio > to_ratio
            h = w
            RATIO_X
          else
            RATIO_Y
          end

        return h.to_i > w.to_i ? value * (h / w) : value
      end
    end
  end
end

require 'media/image/editing/cmd/text_to_image'
