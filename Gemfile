source 'https://rubygems.org'
ruby '2.4.0'

# Use ActiveModel has_secure_password
gem 'bcrypt',                  '3.1.11'
gem 'bootstrap-sass',          '3.3.6'
gem 'bootstrap-will_paginate', '0.0.10'
gem 'carrierwave',             '0.11.2'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails',            '4.2.1'
gem 'faker',                   '1.6.6'
gem 'fog',                     '1.38.0'
gem 'font-awesome-rails',      '4.7.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder',                '2.4.1'
# Use jquery as the JavaScript library
gem 'jquery-rails',            '4.1.1'
# Fix turbolinks glitches
gem 'jquery-turbolinks',       '2.1.0'
gem 'mini_magick',             '4.5.1'
gem 'momentjs-rails',          '2.9.0'
# Validate phone numbers
gem 'phony_rails',             '0.12.13'
gem 'puma',                    '3.4.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails',                   '5.0.2'
gem 'ransack',                 '1.8.2'
# Use SCSS for stylesheets
gem 'sass-rails',              '5.0.6'
# Easy forms
gem 'simple_form',             '3.3.1'
# Turbolinks makes following links in your web application faster.
# Read more: https://github.com/rails/turbolinks
gem 'turbolinks',              '5.0.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier',                '3.0.0'
gem 'will_paginate',           '3.1.6'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a
  # debugger console
  gem 'byebug',      '9.0.0', platform: :mri
  # Newer version of minitest not working with Rails 5.0.2
  gem 'minitest',              '5.10.1'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3',     '1.3.12'
end

group :development do
  # Improved error screens
  gem 'better_errors',         '2.1.1'
  gem 'binding_of_caller',     '0.7.2'
  gem 'brakeman', :require => false
  # Listen to file modifications and notifiy about the changes
  gem 'listen',                '3.0.8'
  # gem 'rubocop', require: false
  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring',                '1.7.2'
  gem 'spring-watcher-listen', '2.0.0'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console',           '3.1.1'
end

group :test do
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
  gem 'minitest-reporters',       '1.1.9'
  # Provides Travis CI with rack access.
  gem 'rack',                     '2.0.3'
  gem 'rails-controller-testing', '0.1.1'
  # Travis CI Ruby Test Coverage
  gem 'simplecov',                 '0.12.0'
end

group :production do
  gem 'pg',             '0.18.4'
  gem 'rails_12factor', '0.0.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
