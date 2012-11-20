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
    x.save
  end
  
  def has_been_seen
    return false if self.new_record?
    self.seen = true
    self.save
  end
  
  def self.count_tot(an_user_id)
    Notification.where(:user_id => an_user_id).count
  end
  
  def self.last_in_visible_block(an_user_id, an_offset, a_limit)
    Notification.order('created_at DESC').where(:user_id => an_user_id).offset(an_offset).limit(a_limit).last
  end
  
  def self.count_visible_block(an_user_id, an_offset, a_limit)
    Notification.order('created_at DESC').where(:user_id => an_user_id).offset(an_offset).limit(a_limit).count
  end
  
  def self.visible_block(an_user_id, an_offset, a_limit)
    Notification.order('created_at DESC').where(:user_id => an_user_id).offset(an_offset).limit(a_limit)
  end
  
  def self.number_not_seen(an_user_id)
    Notification.where(:seen => false, :user_id => an_user_id).count
  end
  
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
      errors[:seen] << "can't be switched from true to false" if @notification.seen && !self.seen
      errors[:user_id] << "can't be changed" if @notification.user_id != self.user_id
      errors[:message] << "can't be changed" if @notification.message != self.message
    end
  end
  
end
