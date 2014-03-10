source 'https://rubygems.org'

gem 'rails', '4.0.3'

# Gems by group alphabetically sorted
gem 'ancestry'
# TODO Rails 4 di default mette nei cookie, che ora dovrebbero essere crittati quindi sicuri; pensare se ha senso tenere la sessione nel db, altrimenti toglierlo
gem 'activerecord-session_store'
gem 'bcrypt-ruby',              '~> 3.1.2'
gem 'carrierwave'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'erubis'
gem 'eventmachine',                         platforms: :ruby
gem 'facter',                               platforms: :ruby
gem 'jbuilder', '~> 1.2'
gem 'jquery-rails',             '~> 2.1.4'
gem 'kaminari'
gem 'mini_magick',                                             github: 'mdesantis/minimagick', branch: 'batch_compatibility'
gem 'nokogiri',                             platforms: :ruby
gem 'oj'
gem 'pg'
# TODO Toglierlo quando si passa al check dei parametri nel controller
gem 'protected_attributes'
gem 'recursive-open-struct'
gem 'rubyzip'
gem 'schema_plus'
gem 'sdoc'
gem 'subexec',                                                 github: 'mdesantis/subexec'
gem 'tinymce-rails',            '~> 3.0'
gem 'tinymce-rails-langs'
# TODO da mettere dopo
# gem 'turbolinks'
gem 'unicorn',                              platforms: :ruby
gem 'whenever',                                                                                                                 require: false
gem 'win32-dir',                            platforms: :mingw

# TODO ordinare
gem 'bootstrap-sass',          '~> 2.2.2.0'
gem 'coffee-rails',            '~> 4.0.0'
gem 'jquery-fileupload-rails'
gem 'libv8',                   '~> 3.11.8',  platforms: :ruby
gem 'sass-rails',              '~> 4.0.0'
gem 'therubyracer',                          platforms: :ruby
gem 'uglifier',                '>= 1.3.0'

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

group :doc do
  gem 'sdoc', require: false
end

group :irbtools do
  gem 'irbtools', platforms: :ruby
end

group :production do
  gem 'exception_notification'
end
