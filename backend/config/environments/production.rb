Rails.application.configure do
  config.cache_classes = true

  config.eager_load = true

  config.consider_all_requests_local = false

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  config.assets.compile = false

  config.active_storage.service = :local

  config.force_ssl = false

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  config.action_mailer.perform_caching = true
  
  config.action_mailer.raise_delivery_errors = true
  
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.default_url_options = { host: 'doit-app.com' }

  ActionMailer::Base.smtp_settings = {
    address: ENV['SES_SMTP_ADDRESS'],
    port: 587,
    domain: 'doit-app.com',
    authentication: :login,
    user_name: ENV['SES_SMTP_USER'],
    password: ENV['SES_SMTP_PASSWORD'],
    enable_starttls_auto: true
  }

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.log_formatter = ::Logger::Formatter.new

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false

  config.require_master_key = false
end
