source 'https://rubygems.org'

gem 'rails', '4.1.0'

group :development do
	gem 'sqlite3'
    gem 'better_errors'
    gem 'binding_of_caller'
	gem 'capistrano', '~> 3.1.0'
	gem 'capistrano-rails', '~> 1.1.0'
end

gem "spring", group: [:development, :test]

group :test do
	gem "rspec-rails"
	gem "spring-commands-rspec"
	gem "guard-rspec"
end

group :production do
	# use postgresql as database
	gem 'pg'
end

# Use sass, coffee and haml for simpler code
gem 'sass-rails', '~> 4.0.2'
gem 'haml'
gem 'haml-rails'
gem 'coffee-rails', '~> 4.0.0'

gem 'jquery-datatables-rails', '~> 3.1.1'
gem 'jquery-rails', '>= 3.0.0'
gem 'jquery-ui-rails', '5.0.0'

gem "therubyracer"

# use yui and uglifier for asset compression
gem 'yui-compressor'
gem 'uglifier', '>= 1.3.0'

# timezone data
gem 'tzinfo-data'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
