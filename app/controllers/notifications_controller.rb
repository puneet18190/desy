class NotificationsController < ApplicationController
  
  def seen
    @notifications = Notification.not_seen(@current_user.id)
    @notifications.each do |n|
      n.has_been_seen
    end
  end
  
end
