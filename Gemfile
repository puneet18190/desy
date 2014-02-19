source 'https://rubygems.org'

gem 'rails', '3.2.17'
gem 'pg'

# Gems by group alphabetically sorted
gem 'ancestry'
gem 'bcrypt-ruby',              '~> 3.0.0'
gem 'carrierwave'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'erubis'
gem 'eventmachine',                         platforms: :ruby
gem 'facter'
gem 'jquery-rails',             '~> 2.1.4'
gem 'kaminari'
gem 'mini_magick',                                             github: 'mdesantis/minimagick', branch: 'batch_compatibility'
gem 'nokogiri'
gem 'oj'
gem 'recursive-open-struct'
gem 'rubyzip'
gem 'schema_plus'
gem 'sdoc'
gem 'subexec',                                                 github: 'mdesantis/subexec'
gem 'tinymce-rails',            '~> 3.0'
gem 'tinymce-rails-langs'
gem 'unicorn',                              platforms: :ruby
gem 'whenever',                                                                                                                 require: false
gem 'win32-dir',                            platforms: :mingw

# Gems used only for assets and not required in production environments by default
group :assets do
  gem 'bootstrap-sass',          '~> 2.2.2.0'
  gem 'coffee-rails',            '~> 3.2.1'
  gem 'jquery-fileupload-rails'
  gem 'libv8',                   '~> 3.11.8',  platforms: :ruby
  gem 'sass-rails',              '~> 3.2.3'
  gem 'therubyracer',                          platforms: :ruby
  gem 'uglifier',                '>= 1.0.3'
end

group :development do
  gem 'irb-benchmark'
  gem 'mailcatcher',   platforms: :ruby
  # Basta assets che monopolizzano il log dell'application server!
  gem 'quiet_assets'
  gem 'rails-erd'
end

group :development, :test do
  gem 'colorize'
  gem 'rspec-rails'
end

group :irbtools do
  gem 'irbtools', platforms: :ruby
end

group :production do
  gem 'exception_notification'
end
