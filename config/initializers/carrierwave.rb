if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: AWS_ACCESS_KEY_ID,
      aws_secret_access_key: AWS_SECRET_KEY_ID,
      region: AWS_REGION
    }

    config.fog_directory = S3_DIRECTORY
    config.cache_storage = :fog
  end
end
