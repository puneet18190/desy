require 'pp'

require 'exception_notification'
require 'exception_notification/rails'

require 'dumpable'

# Contains the custom notifiers
module ExceptionNotifier
  
  # Notifier for the exception logs
  class LogNotifier

    module ExceptionLogger
      LOG_FOLDER = Pathname(Rails.application.config.paths['log'].first).dirname
      # Path to the errors log file
      LOG_PATH   = LOG_FOLDER.join "exceptions.#{Rails.env}.log"
      # logger instance
      LOGGER     = Logger.new(LOG_PATH)

      LOGGER.level     = Logger::ERROR
      LOGGER.formatter = Logger::Formatter.new

      # Logs exception together with an env hash (which can be +nil+)
      def self.log(exception, env = nil)
        pp_env      = ''.tap { |s| PP.pp(env, s) }
        log_content = { message: exception.message, backtrace: exception.backtrace.join("\n"), env: pp_env }.to_yaml

        LOGGER.error <<-LOG

-- BEG EXCEPTION (#{exception.class}) --
#{log_content}
-- END EXCEPTION (#{exception.class}) --
LOG
      end
    end

    def initialize(options)
    end

    def call(exception, options = {})
      ExceptionLogger.log(exception, options[:env])
    end
  end

  # Notifier for email notifications sent by delayed jobs
  class DelayedJobEmailNotifier < ExceptionNotifier::EmailNotifier

    ENV_ACTION_CONTROLLER_INSTANCE_KEY = 'action_controller.instance'

    # Used by exceptions logging in order to provide controller informations avoiding the dump the controller instance entirely
    class ControllerInfo
      attr_reader :controller_name, :action_name

      def initialize(controller_name, action_name)
        @controller_name, @action_name = controller_name, action_name
      end
    end

    def call_with_delayed_job_support(exception, options = {})
      delayed_call marshal_dumpable_exception(exception), marshal_dumpable_options(options)
    end
    alias_method_chain :call, :delayed_job_support

    private

    def delayed_call(exception, options = {})
      call_without_delayed_job_support exception, options
    end
    handle_asynchronously :delayed_call

    def marshal_dumpable_exception(exception)
      Dumpable.exception(exception)
    end

    def marshal_dumpable_options(options)
      options[:env] = marshal_dumpable_env options[:env]
      options
    end

    def marshal_dumpable_env(env)
      return env if env.empty?

      env = env.dup

      env[ENV_ACTION_CONTROLLER_INSTANCE_KEY] = 
        ControllerInfo.new( env[ENV_ACTION_CONTROLLER_INSTANCE_KEY].try(:controller_name) ,
                            env[ENV_ACTION_CONTROLLER_INSTANCE_KEY].try(:action_name)     )

      Dumpable.hash(env)
    end
  end
end

ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  config.ignored_exceptions = []

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  config.ignore_if do |exception, options|
    not Rails.env.production?
  end

  # Notifiers =================================================================

  # Email notifier sends notifications by email.
  # config.add_notifier :email, {
  #   :email_prefix         => "[ERROR] ",
  #   :sender_address       => %{"Notifier" <notifier@example.com>},
  #   :exception_recipients => %w{exceptions@example.com}
  # }

  # Exception logs
  config.add_notifier :log, {}

  # Email notifications sent by delayed jobs
  config.add_notifier :delayed_job_email, {
    email_prefix:         "[#{SETTINGS['application_name']}] "            ,
    sender_address:       %Q{"Error" #{SETTINGS['application']['email']}} ,
    exception_recipients: SETTINGS['application']['maintainer']['emails']
  }

end
