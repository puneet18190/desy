require 'notification'

# +DelayedJob+ job which sends the user web notifications
class NotificationsJob < Struct.new(:user_ids, :message)
  def perform
    user_ids.each{ |id| Notification.send_to(id, message) }
  end
end
