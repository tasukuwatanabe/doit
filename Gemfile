source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'jbuilder', '~> 2.7'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.3'
gem 'parallel'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'bcrypt'
gem 'date_validator'
gem 'nokogiri'
gem 'rails-i18n'
gem 'valid_email2'
gem 'carrierwave'
gem 'mini_magick'
gem 'meta-tags'
gem 'dotenv-rails'
gem 'whenever', require: false
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'rename'
gem 'rack-cors'

# Sprockets4.0だと、app/assetsディレクトリを削除するとSprockets::Railtie::ManifestNeededErrorが発生する
gem 'sprockets', '~> 3.7.2'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'awesome_print'
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano3-nginx', '~> 2.0'
  gem 'pry-rails'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  gem 'spring-commands-rspec'
  gem 'bullet'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'rspec_junit_formatter'
end

group :production do
  gem 'unicorn'
  gem 'fog-aws'
end