module UserImageHelper
  def user_image(user)
    image_path = if user.user_image?
                   user.user_image.to_s
                 else
                   if Rails.env.production?
                     'https://doit-image.s3-ap-northeast-1.amazonaws.com/user_images/default.jpg'
                   else
                     '/user_images/default.jpg'
                   end
                 end
    image_tag(image_path, alt: user.username, class: 'user-icon')
  end
end
