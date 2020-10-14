user = User.create!(
  username: 'ゲストユーザー',
  email: 'guest@example.com',
  password: SecureRandom.urlsafe_base64,
  user_image: nil
)

titles = %w[
  Railsの勉強
  JavaScriptの勉強
  PHPを勉強する
  Rubyを勉強する
  Pythonを勉強する
  Goを勉強する
  AWSを勉強する
  Dockerを勉強する
  CircleCIを勉強する
  Gitを勉強する
  掃除機をかける
  オンライン英会話
  読書
  ジム
]

# Todoを作成
titles.length.times do |n|
  case n % 7
  when 0
    todo_date = Date.today - 3.days
  when 1
    todo_date = Date.today - 2.days
  when 2
    todo_date = Date.today.yesterday
  when 3
    todo_date = Date.today
  when 4
    todo_date = Date.today.tomorrow
  when 5
    todo_date = Date.today + 2.days
  when 6
    todo_date = Date.today + 3.days
  end

  user.todos.create!(
    title: titles[n],
    todo_date: todo_date,
    status: n.even?
  )
end

# ショートカットを作成
5.times do |n|
  user.shortcuts.create!(
    title: titles[n]
  )
end

# Routineを作成
3.times do |n|
  user.routines.create!(
    title: titles[n],
    start_date: Date.today - 3.days,
    end_date: Date.today + 3.days
  )

  7.times do |m|
    routine = Routine.find_by(title: titles[n])
    user.todos.create!(
      title: routine.title,
      routine_id: routine.id,
      todo_date: routine.start_date + m.days,
      status: m.even?
    )
  end
end
