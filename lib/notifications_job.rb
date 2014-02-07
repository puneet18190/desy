require 'notification'

# +DelayedJob+ job which sends the user web notifications
class NotificationsJob < Struct.new(:user_ids, :message)
  def perform
    user_ids.each{ |id| Notification.send_to(id, message) } # TODO sendtto
  rescue => e
    ExceptionLogger.log e
    ExceptionNotifier.notify_exception e
    raise e
  end
end
