class Notification < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :user_id, :message
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_inclusion_of :seen, :in => [true, false]
  validate :validate_associations, :validate_seen, :validate_impossible_changes
  
  before_validation :init_validation
  
  def self.send_to(an_user_id, msg)
    x = Notification.new
    x.user_id = an_user_id
    x.message = msg
    x.seen = false
    puts an_user_id.inspect
    puts x.errors.inspect if !x.save
  end
  
  def has_been_seen
    return false if self.new_record?
    self.seen = true
    self.save
  end
  
  private
  
  def init_validation
    @notification = Valid.get_association self, :id
    @user = Valid.get_association self, :user_id
  end
  
  def validate_associations
    errors[:user_id] << "doesn't exist" if @user.nil?
  end
  
  def validate_seen
    errors[:seen] << 'must be false when new record' if !@notification && self.seen
  end
  
  def validate_impossible_changes
    if @notification
      errors[:seen] << "can't be switched from true to false" if @notification.seen && !self.seen
      errors[:user_id] << "can't be changed" if @notification.user_id != self.user_id
      errors[:message] << "can't be changed" if @notification.message != self.message
    end
  end
  
end
