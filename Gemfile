source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '~> 2.2.2.0'
  gem 'libv8', '~> 3.11.8', :platforms => :ruby
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
  #gem "jquery-fileupload-rails"
end

group :development do
  gem 'rails-erd'
  gem 'mailcatcher', platforms: :ruby
  # Basta assets che monopolizzano il log dell'application server!
  gem 'quiet_assets'
  gem 'irb-benchmark'
end

gem 'sdoc'
gem 'irbtools', group: 'irbtools', platforms: :ruby

group :development, :test do
  gem 'rspec-rails'
  gem 'colorize'
end

gem 'oj'
gem 'jquery-rails', '~> 2.1.4'
gem 'schema_plus'
gem 'recursive-open-struct'
gem "subexec", github: "ProGNOMmers/subexec"
gem 'mini_magick', github: 'ProGNOMmers/minimagick', branch: 'batch_compatibility'
gem 'carrierwave'
gem 'tinymce-rails', '~> 3.0'
gem 'tinymce-rails-langs'
gem 'kaminari'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'unicorn', :platforms => :ruby
gem 'daemons'
gem 'eventmachine', platforms: :ruby
gem 'delayed_job_active_record'
gem 'ancestry'
gem 'exception_notification', github: "ProGNOMmers/exception_notification", group: :production
gem 'facter'
gem 'whenever', :require => false
gem 'win32-dir', platforms: :mingw
