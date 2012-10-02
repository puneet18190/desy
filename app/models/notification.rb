class Notification < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :user_id, :message
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_inclusion_of :seen, :in => [true, false]
  validate :validate_associations, :validate_seen, :validate_impossible_changes
  
  before_validation :init_validation
  
  private
  
  def init_validation
    @notification = Valid.get_association self, :id
  end
  
  def validate_associations
    errors[:user_id] << "doesn't exist" if !User.exists?(self.user_id)
  end
  
  def validate_seen
    errors[:seen] << 'must be false when new record' if !@notification && self.seen
  end
  
  def validate_impossible_changes
    if @notification
      errors[:seen] << "can't be set from true to false" if @notification.seen && !self.seen
      errors[:user_id] << "can't be changed" if @notification.user_id != self.user_id
      errors[:message] << "can't be changed" if @notification.message != self.message
    end
  end
  
end
