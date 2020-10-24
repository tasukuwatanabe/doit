3.times do |n|
  User.create!(
    username: "testuser#{n}",
    email: "testuser#{n}@example.com",
    password: 'password',
    activated: true,
    activated_at: Time.zone.now
  )
end
