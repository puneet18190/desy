source 'https://rubygems.org'

gem 'rails', '3.2.14'
gem 'pg'

gem 'ancestry'
gem 'bcrypt-ruby',              '~> 3.0.0'
gem 'carrierwave'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'eventmachine',                         platforms: :ruby
gem 'facter'
gem 'jquery-rails',             '~> 2.1.4'
gem 'kaminari'
gem 'mini_magick',                                             github: 'ProGNOMmers/minimagick', branch: 'batch_compatibility'
gem 'oj'
gem 'recursive-open-struct'
gem 'rubyzip'
gem 'schema_plus'
gem 'sdoc'
gem 'subexec',                                                 github: 'ProGNOMmers/subexec'
gem 'tinymce-rails',            '~> 3.0'
gem 'tinymce-rails-langs'
gem 'unicorn',                              platforms: :ruby
gem 'whenever',                                                                                                                 require: false
gem 'win32-dir',                            platforms: :mingw

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',              '~> 3.2.3'
  gem 'coffee-rails',            '~> 3.2.1'
  gem 'bootstrap-sass',          '~> 2.2.2.0'
  gem 'libv8',                   '~> 3.11.8',  platforms: :ruby
  gem 'therubyracer',                          platforms: :ruby
  gem 'uglifier',                '>= 1.0.3'
  gem 'jquery-fileupload-rails'
end

group :development do
  gem 'rails-erd'
  gem 'mailcatcher',  platforms: :ruby
  # Basta assets che monopolizzano il log dell'application server!
  gem 'quiet_assets'
  gem 'irb-benchmark'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'colorize'
end

group :irbtools do
  gem 'irbtools', platforms: :ruby
end

group :production do
  gem 'exception_notification', github: 'ProGNOMmers/exception_notification'
end
