class NotificationsController < ApplicationController
  
  def seen
    Notification.not_seen(@current_user.id).each do |n|
      n.has_been_seen
    end
  end
  
end
