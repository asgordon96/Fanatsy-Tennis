source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# use thin as the webserver
gem 'thin'

# Use postresql as the database for Active Record
gem 'pg', '~> 0.15.1'

# Nokogiri for parsing HTML to get ATP player data
gem "nokogiri", "~> 1.6.0"

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# use bootstrap for css and js
gem 'bootstrap-sass'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

gem "faye", "~> 0.8.9" # use faye for pub/sub messaging for live updating

gem 'rufus-scheduler', :require => false # gem for daily updates

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  gem 'pry-rails'
  gem 'guard-rspec'
  gem 'rspec-rails'
  gem 'reek', :require => false
  gem 'brakeman', :require => false
  gem 'simplecov', :require => false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
