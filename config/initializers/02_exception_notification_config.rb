require 'exception_notification'

require 'dumpable'

# Provides the errors logging logic
# TODO vedere se da usare
module ExceptionsLogger
  # Path to the errors log file
  LOG_PATH = Rails.root.join 'log', "exceptions.#{Rails.env}.log"
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

# Used by exceptions logging in order to provide controller informations avoiding the whole controller instance dump
class ControllerInfo
  attr_reader :controller_name, :action_name

  def initialize(controller_name, action_name)
    @controller_name, @action_name = controller_name, action_name
  end
end

# +DelayedJob+ job which sends the mail notifications of the errors occured
class ExceptionNotifierJob < Struct.new(:exception, :env)
  def perform
    ExceptionNotifier.notify_exception(exception, env: env)
  end
end

module ExceptionNotifier
  class DelayedJobNotifier
    ENV_ACTION_CONTROLLER_INSTANCE_KEY = 'action_controller.instance'

    def initialize(options)
    end

    def call(exception, options = {})
      puts '####################################################################'

      # pp self, marshal_dumpable_exception, marshal_dumpable_env

      Delayed::Job.enqueue ExceptionNotifierJob.new marshal_dumpable_exception(exception),
                                                    marshal_dumpable_env(options[:env])


      puts '####################################################################'
    end

    private
    def marshal_dumpable_exception(exception)
      Dumpable.exception(exception)
    end

    def marshal_dumpable_env(env)
      return env if env.empty?


      # pp env[ENV_ACTION_CONTROLLER_INSTANCE_KEY]

      env[ENV_ACTION_CONTROLLER_INSTANCE_KEY] = ControllerInfo.new env[ENV_ACTION_CONTROLLER_INSTANCE_KEY].try(:controller_name),
                                                                   env[ENV_ACTION_CONTROLLER_INSTANCE_KEY].try(:action_name)

      env = Dumpable.hash(env)

      env
    end
  end
end

module ExceptionNotification
  class Engine < ::Rails::Engine
    config.exception_notification = ExceptionNotifier
    config.exception_notification.logger = Rails.logger

    config.app_middleware.use ExceptionNotification::Rack, delayed_job: {
                                                             email_prefix:         "[#{SETTINGS['application_name']}] "            ,
                                                             sender_address:       %Q{"Error" #{SETTINGS['application']['email']}} ,
                                                             exception_recipients: SETTINGS['application']['maintainer']['emails']
                                                           },
                                                           ignore_exceptions: []
  end
end



ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  # config.ignored_exceptions += %w{ActionView::TemplateError CustomError}

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  # config.ignore_if do |exception, options|
  #   not Rails.env.production?
  # end

  # Notifiers =================================================================

  # Email notifier sends notifications by email.
  # config.add_notifier :email, {
  #   :email_prefix         => "[ERROR] ",
  #   :sender_address       => %{"Notifier" <notifier@example.com>},
  #   :exception_recipients => %w{exceptions@example.com}
  # }

  # Campfire notifier sends notifications to your Campfire room. Requires 'tinder' gem.
  # config.add_notifier :campfire, {
  #   :subdomain => 'my_subdomain',
  #   :token => 'my_token',
  #   :room_name => 'my_room'
  # }

  # HipChat notifier sends notifications to your HipChat room. Requires 'hipchat' gem.
  # config.add_notifier :hipchat, {
  #   :api_token => 'my_token',
  #   :room_name => 'my_room'
  # }

  # Webhook notifier sends notifications over HTTP protocol. Requires 'httparty' gem.
  # config.add_notifier :webhook, {
  #   :url => 'http://example.com:5555/hubot/path',
  #   :http_method => :post
  # }

end
