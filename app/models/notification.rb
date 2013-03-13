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
  
  def self.test_all_to(an_user_id)
    Notification.delete_all
    Notification.send_to an_user_id, t('notifications.lessons.destroyed', :user_name => 'Luciano Moggi', :lesson_title => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.lessons.link_sent', :title => 'Gelato al cioccolato', :message => 'Guardate che bella lezione!', :emails => 'moggi@figc.it, carraro@figc.it')
    Notification.send_to an_user_id, t('notifications.lessons.modified', :lesson_title => 'Gelato al cioccolato', :message => 'Ho aggiornato le ultime slides', :link => 'www.google.com')
    Notification.send_to an_user_id, t('notifications.lessons.unpublished', :user_name => 'Luciano Moggi', :lesson_title => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.audio.compose.update.started', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.audio.compose.update.ok', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.audio.compose.update.failed', :item => 'Gelato al cioccolato', :link => 'www.google.com')
    Notification.send_to an_user_id, t('notifications.audio.compose.create.started', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.audio.compose.create.ok', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.audio.compose.create.failed', :item => 'Gelato al cioccolato', :link => 'www.google.com')
    Notification.send_to an_user_id, t('notifications.audio.compose.upload.started', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.audio.compose.upload.ok', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.audio.compose.upload.failed', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.video.compose.update.started', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.video.compose.update.ok', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.video.compose.update.failed', :item => 'Gelato al cioccolato', :link => 'www.google.com')
    Notification.send_to an_user_id, t('notifications.video.compose.create.started', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.video.compose.create.ok', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.video.compose.create.failed', :item => 'Gelato al cioccolato', :link => 'www.google.com')
    Notification.send_to an_user_id, t('notifications.video.compose.upload.started', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.video.compose.upload.ok', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, t('notifications.video.compose.upload.failed', :item => 'Gelato al cioccolato')
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
