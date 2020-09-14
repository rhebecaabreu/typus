source 'https://rubygems.org'

# Declare your gem's dependencies in typus.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Use SCSS for stylesheets
#gem 'sass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Database Adapters
#gem 'pg'
gem 'mysql2'

# Typus can manage lists, trees, trashes, so we want to enable this stuff
# on the demo.
gem 'acts_as_list', github: 'typus/acts_as_list'
gem 'acts_as_tree'
gem 'rails-permalink'
#gem 'rails-trash', github: 'fesplugas/rails-trash'

gem 'rails-trash', :github => 'trilogyinteractive/rails-trash'


# Rich Text Editor
gem 'ckeditor-rails'

# Alternative authentication
gem 'devise'

# Asset Management
gem 'dragonfly'
gem 'rack-cache', require: 'rack/cache'
gem 'paperclip'
gem 'carrierwave'

# MongoDB
# gem 'mongoid', github: 'mongoid/mongoid'

# Testing stuff
group :test do
  gem 'minitest-rails-capybara' # makes capybara's DSL methods available in Rails minitests
  gem 'poltergeist' # a headless browser (webkit) as capybara driver
  gem 'rails-controller-testing'
end

gem 'puma'
