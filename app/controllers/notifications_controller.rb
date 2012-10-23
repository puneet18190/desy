class NotificationsController < ApplicationController
  
  before_filter :initialize_notification_with_owner, :only => :destroy
  before_filter :initialize_notification_offset
  
  def seen
    set_visible_as_seen
  end
  
  def destroy
    @notification.destroy if @ok
    initialize_notifications
  end
  
  def get_new_block
    initialize_notifications
    set_visible_as_seen
  end
  
  private
  
  def set_visible_as_seen
    @notifications = Notification.not_seen(@current_user.id, @offset_notifications)
    @notifications.each do |n|
      n.has_been_seen
    end
    @number_not_seen = Notification.number_not_seen(@current_user.id)
  end
  
  def initialize_notification_offset
    @offset_notifications = correct_integer?(params['offset']) ? params['offset'].to_i : 0
  end
  
  def initialize_notification_with_owner
    @notification_id = correct_integer?(params[:notification_id]) ? params[:notification_id].to_i : 0
    @notification = Notification.find_by_id @notification_id
    @ok = !@notification.nil?
    @ok = (@current_user.id == @notification.user_id) if @ok
  end
  
end
