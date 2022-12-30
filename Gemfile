source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

gem 'rails', '>= 7.0.4'	# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'bootsnap', require: false # Reduces boot times through caching; required in config/boot.rb

gem 'jbuilder'			# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

gem 'puma' # Better web server
gem 'pg' # Only PostgreSQL is supported!
gem 'rack-cors'	# Allowing cross-origin clients.. which is all of them.

# Service-checking stuff.
gem 'net-ping'		# ICMP pings.
gem 'puppeteer-ruby'	# HTTP screenshots!

gem 'sdoc', group: :doc # bundle exec rake doc:rails generates the API under doc/api.

group :development, :test do
    gem "debug", platforms: %i[ mri mingw x64_mingw ]
    gem 'guard'
    gem 'guard-minitest'

    gem 'rails-controller-testing'
end

group :development do
    # gem 'web-console', '~> 2.0'     # Access an IRB console on exception pages or by using <%= console %> in views
    # gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'railroady'
    gem 'rubocop-rails' # For editor reformatting support
    gem 'web-console'
    # gem 'rack-mini-profiler', '~> 2.0'
    # gem 'listen', '~> 3.3'
    # gem 'binding_of_caller'
    gem 'prettier'
    gem 'rubocop'
    gem 'reek'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
