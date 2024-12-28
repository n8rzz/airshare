source "https://rubygems.org"

ruby "3.3.0"

gem "bootsnap", require: false
gem "dotenv-rails", "~> 3.1"
gem "importmap-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "rails", "~> 7.1.3", ">= 7.1.3.2"
gem "sprockets-rails"

# Authentication
gem "devise", "~> 4.9"
gem "omniauth", "~> 2.1"
gem "omniauth-google-oauth2", "~> 1.1"
gem "omniauth-microsoft-office365", "~> 0.0.8"
gem "omniauth-rails_csrf_protection", "~> 1.0" # For security
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "database_cleaner", "~> 2.0"
  gem "factory_bot_rails", "~> 6.4"
  gem 'rspec-rails', '~> 6.0.0'
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "web-console"
  gem "guard"
  gem "guard-rspec"
  gem "guard-bundler"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Process manager for running multiple processes
  gem "foreman"
end

group :test do
  gem "capybara", "~> 3.39"
  gem "selenium-webdriver", "~> 4.17"
  gem "shoulda-matchers", "~> 5.0"
end
