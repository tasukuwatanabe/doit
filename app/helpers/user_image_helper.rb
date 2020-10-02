module UserImageHelper
  def user_image(user)
    image_path = user.user_image? ? user.user_image.to_s : '/user_images/default.jpg'
    image_tag(image_path, alt: user.username, class: 'user-icon')
  end
end
