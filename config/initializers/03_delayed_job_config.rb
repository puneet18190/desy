# The requires are needed by delayed_job jobs (excluding previously loaded initializers)
require 'media'
require 'notifications_job'
require 'eventmachine' unless WINDOWS

# Delayed Jobs configuration
Delayed::Worker.destroy_failed_jobs = Rails.env.production?
Delayed::Worker.delay_jobs = !Rails.env.test?