require 'media'

module Media
  module AllowedDurationRange

    private
    def allowed_duration_range?(duration, other_duration)
      ((duration-self.duration_threshold)..(duration+self.duration_threshold)).include? other_duration
    end

  end
end