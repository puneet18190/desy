require 'media'

module Media
  module SimilarDurations

    private
    def similar_durations?(duration, other_duration)
      ((duration-self.class::DURATION_THRESHOLD)..(duration+self.class::DURATION_THRESHOLD)).include? other_duration
    end

  end
end