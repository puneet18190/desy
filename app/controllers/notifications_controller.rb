class NotificationsController < ApplicationController
  
  before_filter :initialize_notification_with_owner, :only => [:seen, :destroy]
  before_filter :initialize_notification_offset, :only => :get_new_block
  
  def seen
    @ok = @notification.has_been_seen if @ok
    @new_notifications = Notification.number_not_seen(@current_user.id)
  end
  
  def destroy
    if @ok
      @notification.destroy
      initialize_notifications
      @next_notification = @notifications.last
      @load_new = (@offset_notifications == CONFIG['notifications_loaded_together'])
    end
  end
  
  def get_new_block
    initialize_notifications
  end
  
  private
  
  def initialize_notification_offset
    @ok = !params['offset'].blank?
    @offset_notifications = (correct_integer?(params['offset']) ? params['offset'].to_i : 0) if @ok
  end
  
  def initialize_notification_with_owner
    @notification_id = correct_integer?(params[:notification_id]) ? params[:notification_id].to_i : 0
    @notification = Notification.find_by_id @notification_id
    @ok = !@notification.nil?
    @ok = (@current_user.id == @notification.user_id) if @ok
  end
  
end
