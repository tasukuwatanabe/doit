titles = %w[
  燃えるゴミを捨てる
  掃除機をかける
  子供を迎えにいく
  オンライン英会話
  読書
  ジム
  Railsの勉強
  JavaScriptの勉強
  ウェブ制作案件
  PHPを勉強する
  Rubyを勉強する
  Pythonを勉強する
  Goを勉強する
  AWSを勉強する
  親に電話をかける
]

titles.length.times do |n|
  case n % 3
  when 0
    todo_date = Date.today.yesterday
  when 1
    todo_date = Date.today
  when 2
    todo_date = Date.today.tomorrow
  end

  Todo.create!(
    title: titles[n],
    body: n.even? ? 'メモを残すことができます' : nil,
    user_id: User.find_by(email: 'testuser1@example.com').id,
    todo_date: todo_date
  )
end
