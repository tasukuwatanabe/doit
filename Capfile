require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'whenever/capistrano'
require 'capistrano/nginx'

Dir.glob('lib/capistrano/tasks/*.rb').each { |r| import r }
