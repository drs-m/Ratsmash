source 'https://rubygems.org'

gem 'rails', '4.1.0'

# use unicorn as the webserver: 'gem install foreman' -> 'foreman start'
gem 'unicorn'

group :development do
	gem 'sqlite3'
end

group :production do
	# use postgresql in production
	gem 'pg'
	# gem for heroku
	gem 'rails_12factor'
end

# Use sass, coffee and haml for simpler code
gem 'sass-rails', '~> 4.0.2'
gem 'haml'
gem 'coffee-rails', '~> 4.0.0'

# use yui and uglifier for asset compression
gem 'yui-compressor'
gem 'uglifier', '>= 1.3.0'

gem 'jquery-rails'
# gem 'jquery-ui-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
