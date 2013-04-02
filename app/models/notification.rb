# == Description
#
# ActiveRecord class that corresponds to the table +notifications+: this table contains messages sent by the application to the users.
#
# == Fields
#
# * *user_id*: reference to the User who received the notification
# * *message*: message
# * *seen*: boolean, +true+ if the User has already seen the notification
#
# == Associations
#
# * *user*: reference to the User who received the notification (*belongs_to*)
#
# == Validations
#
# * *presence* with numericality and existence of associated record for +user_id+
# * *presence* for +message+
# * *inclusion* of +seen+ in [+true+, +false+]
# * *if* *new* *record*, +seen+ must be false
# * *modifications* *not* *available* for the three fields
#
# == Callbacks
#
# None
#
# == Database callbacks
#
# None
#
class Notification < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :user_id, :message
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_inclusion_of :seen, :in => [true, false]
  validate :validate_associations, :validate_seen, :validate_impossible_changes
  
  before_validation :init_validation
  
  # Block of notifications sent for each job
  SENDING_SLICES_AMOUNT = 1_000
  
  # === Description
  #
  # Sends a notification to one or more users
  #
  # === Args
  #
  # * *user_id_or_user_ids*: if it's an Integer, it sends the notification to a single user, otherwise splits the block of notifications and uses thread to send them
  # * *message*: the content of the notification
  #
  def self.send_to(user_id_or_user_ids, message)
    case user_id_or_user_ids
    when Array
      user_id_or_user_ids.each_slice(SENDING_SLICES_AMOUNT) { |slice| Delayed::Job.enqueue NotificationsJob.new(slice, message) }
    else
      return new do |n|
        n.user_id = user_id_or_user_ids
        n.message = message
        n.seen = false
      end.save
    end
    nil
  end
  
  # === Description
  #
  # Sets +seen+ as +true+. Used in NotificationsController#seen
  #
  def has_been_seen
    return false if self.new_record?
    self.seen = true
    self.save
  end
  
  private
  
  # Initializes validation objects (see Valid.get_association)
  def init_validation # :doc:
    @notification = Valid.get_association self, :id
    @user = Valid.get_association self, :user_id
  end
  
  # Validates the presence of all the associated objects
  def validate_associations # :doc:
    errors.add(:user_id, :doesnt_exist) if @user.nil?
  end
  
  # Validates that +seen+ must be false if the notification is a new record
  def validate_seen # :doc:
    errors.add(:seen, :must_be_false_if_new_record) if !@notification && self.seen
  end
  
  # If not a new record, it validates that no field can be changed
  def validate_impossible_changes # :doc:
    if @notification
      errors.add(:seen, :cant_be_switched_from_true_to_false) if @notification.seen && !self.seen
      errors.add(:user_id, :cant_be_changed) if @notification.user_id != self.user_id
      errors.add(:message, :cant_be_changed) if @notification.message != self.message
    end
  end
  
end
