class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def size_range
    1..3.megabytes
  end

  def store_dir
    'user_icons/'
  end

  def default_url(*_args)
    "user_icons/default.jpg"
  end

  process resize_to_fill: [300, 300]

  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  def filename
    "user_#{model.id}.jpg" if original_filename
  end
end
