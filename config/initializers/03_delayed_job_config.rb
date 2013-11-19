# The requires are needed by delayed_job jobs (excluding previously loaded initializers)
require 'media'
require 'notifications_job'
require 'eventmachine' unless WINDOWS

# Detect whether we are in a Delayed::Job process
DELAYED_JOB = begin
  basename  = File.basename $0
  arguments = $*

  ( basename == 'delayed_job' )                                ||
  ( basename == 'rake' && arguments.grep(/\Ajobs:/).present? )
end

if DELAYED_JOB
  # ActiveRecord::Base.logger = ActiveSupport::TaggedLogging.new(Logger.new(Except))
  ActiveRecord::Base.logger = ActiveSupport::TaggedLogging.new Logger.new LOG_FOLDER.join "delayed_job.activerecord.#{Rails.env}.log"
end

# Delayed::Job configuration
Delayed::Worker.destroy_failed_jobs = Rails.env.production?
Delayed::Worker.delay_jobs = !Rails.env.test?
