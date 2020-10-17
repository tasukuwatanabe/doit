module UserImageHelper
  def user_image(user)
    image = user.sns_profile_image || user.user_image.url
    image_tag(image, alt: user.username + 'アイコン', class: 'user-icon')
  end
end
