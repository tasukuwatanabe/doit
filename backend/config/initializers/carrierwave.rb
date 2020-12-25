require_relative "constants"

CarrierWave.configure do |config|
  config.asset_host = Constants::SERVER_HOST

  if Rails.env.production?
    config.fog_directory = ENV['S3_DIRECTORY']
    config.cache_storage = :fog
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_KEY_ID'],
      region: 'ap-northeast-1'
    }
  end
end