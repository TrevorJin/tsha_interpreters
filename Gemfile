source 'https://rubygems.org'
ruby '2.4.0'

# Use ActiveModel has_secure_password
gem 'bcrypt',                  '3.1.11'
gem 'bootstrap-sass',          '3.3.7'
gem 'bootstrap-will_paginate', '0.0.10'
gem 'carrierwave',             '1.2.2'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails',            '4.2.2'
gem 'faker',                   '1.8.7'
gem 'fog',                     '2.0.0'
gem 'font-awesome-rails',      '4.7.0.4'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder',                '2.7.0'
# Use jquery as the JavaScript library
gem 'jquery-rails',            '4.3.3'
# Fix turbolinks glitches
gem 'jquery-turbolinks',       '2.1.0'
gem 'mini_magick',             '4.8.0'
gem 'momentjs-rails',          '2.20.1'
# Validate phone numbers
gem 'phony_rails',             '0.14.6'
gem 'puma',                    '3.11.4'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails',                   '5.1.0'
gem 'ransack',                 '1.8.8'
# Use SCSS for stylesheets
gem 'sass-rails',              '5.0.7'
# Easy forms
gem 'simple_form',             '4.0.1'
# Turbolinks makes following links in your web application faster.
# Read more: https://github.com/rails/turbolinks
gem 'turbolinks',              '5.1.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier',                '4.1.10'
gem 'will_paginate',           '3.1.6'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a
  # debugger console
  gem 'byebug',      '10.0.2', platform: :mri
  # Newer version of minitest not working with Rails 5.0.2
  gem 'minitest',              '5.10.1'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3',     '1.3.13'
end

group :development do
  # Improved error screens
  gem 'better_errors',         '2.4.0'
  gem 'binding_of_caller',     '0.8.0'
  gem 'brakeman', :require => false
  # Listen to file modifications and notifiy about the changes
  gem 'listen',                '3.1.5'
  # gem 'rubocop', require: false
  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring',                '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console',           '3.6.1'
end

group :test do
  gem 'guard',                    '2.14.2'
  gem 'guard-minitest',           '2.4.6'
  gem 'minitest-reporters',       '1.2.0'
  # Provides Travis CI with rack access.
  gem 'rack',                     '2.0.5'
  gem 'rails-controller-testing', '1.0.2'
  # Travis CI Ruby Test Coverage
  gem 'simplecov',                 '0.16.1'
end

group :production do
  gem 'pg',             '0.18.4'
  gem 'rails_12factor', '0.0.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
