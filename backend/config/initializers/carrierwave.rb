if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_KEY_ID'],
      region: 'ap-northeast-1'
    }

    config.fog_directory = ENV['S3_DIRECTORY']
    config.cache_storage = :fog
  end
end
