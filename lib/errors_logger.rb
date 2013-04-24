# Provides the errors logging logic
module ErrorsLogger
  # Path to the errors log file
  LOG_PATH = Rails.root.join("log/errors.#{Rails.env}.log")
  # logger instance
  LOGGER   = Logger.new(LOG_PATH)

  LOGGER.level     = Logger::ERROR
  LOGGER.formatter = Logger::Formatter.new

  # log action
  def self.log(env, exception)
    LOGGER.error <<-LOG

-- BEG ENV --
#{env.inspect}
-- END ENV --
-- BEG EXCEPTION (#{exception.class}) --
message:    #{exception.message}
backtrace:  #{exception.backtrace.join("\n")}
-- END EXCEPTION (#{exception.class}) --
LOG
  end
end