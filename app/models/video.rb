class Video < MediaElement
  validates_numericality_of :duration, :allow_nil => true, :only_integer => true, :greater_than => 0

  private
  def validate_duration
    errors[:duration] << "can't be blank for videos and audios" if self.duration.nil?
  end
end
