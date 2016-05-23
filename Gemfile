source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.0'

# CI dependency
gem 'mime-types-data', '~> 3.2016.0221'

gem 'bower-rails'

# Database
gem 'pg'

# Assets
gem 'sass-rails', '~> 5.0.1'

# Scripts
gem 'angular-rails-templates'
gem 'angularjs-rails-resource'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'

gem 'jbuilder', '~> 2.2.13'
gem 'devise', '3.5.1'
gem 'devise_token_auth', '0.1.34'
gem 'omniauth-facebook'
gem 'carrierwave', github:'carrierwaveuploader/carrierwave'
gem 'jc-validates_timeliness'

group :development, :test do
  gem 'spring'
  gem 'rspec-rails', '~> 3.0'
  gem 'capybara'
  gem 'selenium-webdriver', '~> 2.53.0'
  gem 'factory_girl_rails', '4.5.0'
  gem 'faker'
  gem 'database_cleaner'
  # Detecting N+1 query problems
  gem 'bullet'

end

group :production do
  gem 'rails_12factor'
  gem 'rails_serve_static_assets'
  gem 'rails_stdout_logging'
end
