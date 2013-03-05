module ErrorsLogger
  LOG_PATH = Rails.root.join("log/errors.#{Rails.env}.log")
  LOGGER   = Logger.new(LOG_PATH)

  LOGGER.level     = Logger::ERROR
  LOGGER.formatter = Logger::Formatter.new

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