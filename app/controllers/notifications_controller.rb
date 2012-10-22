class NotificationsController < ApplicationController
  
  before_filter :initialize_notification_with_owner, :only => :destroy
  
  def seen
    @notifications = Notification.not_seen(@current_user.id, CONFIG['notifications_loaded_together'])
    @notifications.each do |n|
      n.has_been_seen
    end
    initialize_notifications
  end
  
  def destroy
    @notification.destroy if @ok
    initialize_notifications
  end
  
  def get_new_block
    
  end
  
  private
  
  def initialize_notification_with_owner
    @notification_id = correct_integer?(params[:notification_id]) ? params[:notification_id].to_i : 0
    @notification = Notification.find_by_id @notification_id
    @ok = !@notification.nil?
    @ok = (@current_user.id == @notification.user_id) if @ok
  end
  
end
