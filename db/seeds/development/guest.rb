password = SecureRandom.urlsafe_base64

user = User.create!(
  username: 'ゲストユーザー',
  email: 'guest@example.com',
  password: password,
  password_confirmation: password,
  user_image: nil,
  activated: true,
  activated_at: Time.zone.now
)