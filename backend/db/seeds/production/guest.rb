password = SecureRandom.urlsafe_base64

user = User.create!(
  username: 'ゲストユーザー',
  email: 'guest@example.com',
  password: password,
  password_confirmation: password,
  activated: true,
  activated_at: Time.zone.now
)
