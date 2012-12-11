require 'media_editing'
require 'media_editing/video'

module MediaEditing
  module Video
    module AllowedDurationRange

      private
      def allowed_duration_range?(duration, other_duration)
        duration_threshold = self.class::DURATION_THRESHOLD
        ((duration-duration_threshold)..(duration+duration_threshold)).include? other_duration
      end

    end
  end
end