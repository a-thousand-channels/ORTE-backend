# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'puma', '~> 5'
gem 'rails', '~> 6'
gem 'sassc', '~> 2.4'
gem 'sassc-rails'
gem 'uglifier'

gem 'friendly_id', '~> 5.4'

gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 5'
# Use ActiveModel has_secure_password
gem 'bcrypt'
gem 'deep_cloneable', '~> 3'

# custom
gem 'cancancan'
gem 'devise'
gem 'exception_notification'
gem 'foundation-icons-sass-rails'
gem 'foundation-rails', '~> 6'
gem 'haml-rails', '~> 2.0'
gem 'i18n-js', '~> 3'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'mysql2'
gem 'rack-attack'
gem 'rack-cors'
gem 'secure_headers'
gem 'select2-rails'
# NOTE: settingslogic != ruby 3
gem 'settingslogic'
gem 'simple_form'
gem 'sprockets', '~> 4'
gem 'sprockets-es6'

gem 'image_processing'
gem 'mini_racer', '0.4', platforms: :ruby

gem 'acts-as-taggable-on', '~> 9'
gem 'color-generator'
gem 'mini_magick'
gem 'mobility', '~> 1.2'
gem 'rubyzip'
gem 'tinymce-rails', '~> 5'
gem 'turnout'

gem 'net-smtp'

group :staging, :production do
  # gem 'pg'
  gem 'passenger'
end

gem 'coveralls_reborn', '~> 0', require: false

group :development, :test do
  gem 'bundler-audit', require: false
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'ruby_audit', require: false

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3'
  gem 'capybara-chromedriver-logger'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'json-schema'
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'simplecov-small-badge', require: false
  gem 'webdrivers', '~> 5'

  gem 'webmock'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3'
  gem 'web-console', '~> 4'

  gem 'capistrano', '~> 3', require: false
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-rails', '~> 1.6', require: false
  gem 'capistrano-rvm'

  gem 'letter_opener'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 4'

  gem 'brakeman', require: false
  gem 'rubycritic', require: false
end
