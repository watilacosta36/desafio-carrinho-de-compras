source "https://rubygems.org"

ruby "3.3.1"

gem "bootsnap", require: false
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem 'rack-cors'
gem "rails", "~> 7.1.3", ">= 7.1.3.2"
gem "redis", "~> 5.2"
gem "sidekiq", "~> 7.2", ">= 7.2.4"
gem "sidekiq-scheduler", "~> 5.0", ">= 5.0.3"
gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "guard"
gem "guard-livereload", require: false
gem "light-service"

group :development, :test do
  gem "bullet"
  gem "debug", platforms: %i[ mri windows ]
  gem "factory_bot_rails"
  gem "faker"
  gem "pry"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails", "~> 6.1.0"
end

group :test do
  gem 'shoulda-matchers', '~> 6.0'
end
