source 'https://rubygems.org'

gem 'rails', '3.2.12'
gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '~> 2.2.2.0'
  
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'libv8', '~> 3.11.8'
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem "jquery-fileupload-rails"
end

group :development do
  gem 'rails-erd'
  gem 'mailcatcher'
  # Basta assets che monopolizzano il log dell'application server!
  gem 'quiet_assets'
  gem 'irbtools', group: 'irbtools'
  gem 'irb-benchmark'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'colorize'
end

gem 'oj'
gem 'jquery-rails', '~> 2.1.4'
gem 'schema_plus'
gem 'recursive-open-struct'
gem "subexec", :github => "ProGNOMmers/subexec"
gem 'mini_magick'
gem 'carrierwave'
gem 'tinymce-rails'
gem 'tinymce-rails-langs'
gem 'kaminari'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'validates_email_format_of'
gem 'unicorn'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'ancestry'
gem 'exception_notification', :github => "ProGNOMmers/exception_notification", :group => :production
