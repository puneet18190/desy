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

gem 'jquery-rails', '~> 2.1.4'
gem 'oj'
gem 'schema_plus'

group :development do
  gem 'rails-erd'
  gem "letter_opener"
  # Basta assets che monopolizzano il log dell'application server!
  gem 'quiet_assets'
  gem 'irbtools'
  gem 'irb-benchmark'
end

gem 'recursive-open-struct'

gem 'mini_magick'
gem 'carrierwave'
gem 'tinymce-rails'
gem 'tinymce-rails-langs'
gem 'kaminari'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'validates_email_format_of'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

# To use debugger
# gem 'debugger'

group :development, :test do
  gem 'rspec-rails'
  gem 'colorize'
end

gem 'daemons'
gem 'delayed_job_active_record'
gem "subexec", :github => "ProGNOMmers/subexec"
gem 'ancestry'
