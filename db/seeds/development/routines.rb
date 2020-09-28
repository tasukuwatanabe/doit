titles = %w[
  日記を書く
  メールを返す
]

titles.length.times do |n|
  user = User.find_by(email: 'testuser1@example.com')

  Routine.create!(
    title: titles[n],
    body: n.even? ? 'メモを残すことができます' : nil,
    user_id: user.id,
    start_date: Date.today - 1.days,
    end_date: Date.today + 2.days
  )

  routine = Routine.find_by(title: titles[n])

  3.times do |n|
    todo_date = routine.start_date + n.days
    Todo.create!(
      user_id: user.id,
      routine_id: routine.id,
      title: routine.title,
      body: routine.body,
      todo_date: todo_date
    )
  end
end
