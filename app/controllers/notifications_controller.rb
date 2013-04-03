class NotificationsController < ApplicationController
  
  NOTIFICATIONS_LOADED_TOGETHER = SETTINGS['notifications_loaded_together']
  
  before_filter :initialize_notification_with_owner, :only => [:seen, :destroy]
  before_filter :initialize_notification_offset, :only => [:destroy, :get_new_block]
  
  def seen
    if @ok
      @ok = @notification.has_been_seen
    end
    @new_notifications = current_user.number_notifications_not_seen
  end
  
  def destroy
    if @ok
      resp = current_user.destroy_notification_and_reload(@notification.id, @offset_notifications)
      if !resp.nil?
        @offset_notifications = resp[:offset]
        @next_notification = resp[:last]
        @new_notifications = current_user.number_notifications_not_seen
        @tot_notifications = current_user.tot_notifications_number
      else
        @error = I18n.t('activerecord.errors.models.notification.problem_destroying')
      end
    else
      @error = I18n.t('activerecord.errors.models.notification.problem_destroying')
    end
  end
  
  def get_new_block
    @notifications = current_user.notifications_visible_block @offset_notifications, NOTIFICATIONS_LOADED_TOGETHER
    @offset_notifications += @notifications.length
  end
  
  private
  
  def initialize_notification_offset # :doc:
    @offset_notifications = (correct_integer?(params[:offset]) ? params[:offset].to_i : NOTIFICATIONS_LOADED_TOGETHER)
  end
  
  def initialize_notification_with_owner # :doc:
    @notification_id = correct_integer?(params[:notification_id]) ? params[:notification_id].to_i : 0
    @notification = Notification.find_by_id @notification_id
    update_ok(!@notification.nil? && current_user.id == @notification.user_id)
  end
  
end
