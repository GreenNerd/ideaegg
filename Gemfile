source 'http://ruby.taobao.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Html template
gem 'slim-rails', '~> 2.1.5'

# bootstrap theme
gem 'bootstrap-sass', '~> 3.3.0'
gem 'autoprefixer-rails'

# devise
gem 'devise', '~> 3.4.1'

# font awesome
gem 'font-awesome-rails', '~> 4.2.0'

# wysiwyg editor
# This is the right gem to use summernote editor in Rails projects.
gem 'summernote-rails'
gem 'codemirror-rails'

gem 'rails-timeago', '~> 2.0'

# paginate
gem 'kaminari', '~> 0.16.1'

# socialization: follow, like, mention
gem 'acts_as_follower', '>= 0.2.1'
gem 'acts_as_votable', '>= 0.10.0'

# comment
gem 'acts_as_commentable_with_threading', '~> 2.0.0'

# active record soft delete
gem "paranoia", "~> 2.0"

# qiuniu cloud strorage
gem 'qiniu', '~> 6.4.0'

# api
gem 'grape', '~> 0.9.0'
gem 'grape-entity', '~> 0.4.4'
gem 'grape-kaminari'

# markdown
gem 'redcarpet', '~> 3.2.2'

# tag
gem 'acts-as-taggable-on', '~> 3.4'

gem 'rails-i18n'

group :development, :test do
  gem 'rspec-rails', '>= 3.1.0'
  gem 'factory_girl_rails', '>= 4.5.0'
  gem 'ffaker', '>= 1.25.0'
  gem 'seed-fu', '>= 2.3'
  gem 'guard-rspec', '>= 4.3.1'
  gem 'spring-commands-rspec'
  gem 'simplecov', :require => false
  gem 'launchy', '>= 2.4.3'
  gem 'database_cleaner', '>= 1.3.0', :require => false
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  gem 'pry'
  gem 'pry-byebug', '2.0.0'
end

group :development do
  gem 'annotate'
  gem 'pry-rails'
  # Use Capistrano for deployment
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
end

group :test do
  gem 'capybara', '>= 2.4.4'
  gem 'selenium-webdriver', '>= 2.44.0'
  gem 'shoulda-matchers', '>= 2.7.0'
end

group :production do
  # Use PostgreSQL as the database for production
  gem 'pg'
  # Depoy on heroku.com
  gem 'rails_12factor'
  # webserver
  gem 'unicorn'
end

gem 'forgery'

gem 'mailgun_rails'