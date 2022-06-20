require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Doit
  class Application < Rails::Application
    config.api_only = true
    config.load_defaults 6.0

    config.time_zone = 'Tokyo'
    config.i18n.load_path +=
      Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja
    config.action_view.embed_authenticity_token_in_remote_forms = true

    config.generators do |g|
      g.skip_routes true
      g.helper false
      g.assets false
      g.test_framework :rspec
      g.controller_specs false
      g.view_specs false
    end

    config.autoload_paths += Dir["#{config.root}/lib"]
    config.hosts << 'twatanabe-doit-backend.herokuapp.com'

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, key: '_namespace_key'
  end
end
