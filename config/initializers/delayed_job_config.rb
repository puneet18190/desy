# The requires are needed by delayed_job jobs
require 'media'
require 'exception_notifier/notifier'
require 'exception_notifier_job'
require 'notifications_job'
require 'eventmachine'

# Delayed Jobs configuration
Delayed::Worker.destroy_failed_jobs = Rails.env.production?
Delayed::Worker.delay_jobs = !Rails.env.test?