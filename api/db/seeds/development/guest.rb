password = "password"

user = User.create!(
  username: 'ゲストユーザー',
  email: 'guest@example.com',
  password: password,
  password_confirmation: password,
  user_image: nil,
  activated: true,
  activated_at: Time.zone.now
)
