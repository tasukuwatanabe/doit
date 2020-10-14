module UserImageHelper
  def user_image(user)
    image_tag(user.user_image.url, alt: user.username + 'アイコン', class: 'user-icon')
  end
end
