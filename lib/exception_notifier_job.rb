class ExceptionNotifierJob < Struct.new(:env, :exception)
  def perform
    ExceptionNotifier::Notifier.exception_notification(env, exception).deliver
  end
end
