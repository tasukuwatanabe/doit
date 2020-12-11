for i in 1..5 do
  User.create!(
    username: "ユーザー#{i}",
    email: "user#{i}@example.com",
    password: 'password',
    password_confirmation: 'password',
    activated: true,
    activated_at: Time.zone.now
  )
end

User.create!(
  username: "admin",
  email: "sub.t.watanabe@gmail.com",
  password: 'password',
  password_confirmation: 'password',
  activated: true,
  activated_at: Time.zone.now
)