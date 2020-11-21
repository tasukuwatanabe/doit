users = User.all

def createTodo(user, title, label, date, status=false)
  todo = user.todos.build(
    title: title,
    label_id: user.labels.find_by(title: label).id,
    todo_date: Date.today + date.days,
    status: status
  )
  todo.save
end

todos = [
  {title: "メールを返信する", label: "仕事", date: -4},
  {title: "洗濯機を回す", label: "家事", date: -4, status: true},
  {title: "税理士と打ち合わせ", label: "事業", date: -4},
  {title: "JavaScriptの勉強", label: "プログラミング", date: -4},
  {title: "PHPを勉強する", label: "プログラミング", date: -4, status: true},
  {title: "歯磨き粉を買う", label: "家事", date: -4},
  {title: "子供と公園に行く", label: "育児", date: -3},
  {title: "ゴミを捨てる", label: "家事", date: -3},
  {title: "カラオケに行く", label: "娯楽", date: -3, status: true},
  {title: "Progateをやる", label: "プログラミング", date: -3},
  {title: "ブログを書く", label: "事業", date: -3},
  {title: "合コンに参加", label: "娯楽", date: -3, status: true},
  {title: "中国語を勉強する", label: "自己投資", date: -2},
  {title: "HIITトレーニング", label: "スポーツ", date: -2},
  {title: "読書をする", label: "自己投資", date: -2, status: true},
  {title: "Pythonを勉強する", label: "プログラミング", date: -2},
  {title: "ドットインストールをやる", label: "プログラミング", date: -2},
  {title: "飲み会", label: "仕事", date: -2},
  {title: "子供と映画を見る", label: "育児", date: -2},
  {title: "博物館に行く", label: "娯楽", date: -1, status: true},
  {title: "Youtubeを見る", label: "娯楽", date: -1},
  {title: "オンライン英会話", label: "自己投資", date: -1},
  {title: "旅行の計画を立てる", label: "娯楽", date: -1, status: true},
  {title: "Qiitaを書く", label: "プログラミング", date: -1},
  {title: "カフェで仕事をする", label: "仕事", date: -1},
  {title: "合コンに参加", label: "娯楽", date: -1},
  {title: "美術館に行く", label: "娯楽", date: 0},
  {title: "掃除機をかける", label: "家事", date: 0, status: true},
  {title: "事業計画書を書く", label: "事業", date: 0},
  {title: "ジムに行く", label: "スポーツ", date: 0},
  {title: "Rubyを勉強する", label: "プログラミング", date: 0},
  {title: "ユニクロに行く", label: "娯楽", date: 0, status: true},
  {title: "投資の勉強をする", label: "自己投資", date: 0},
  {title: "メールを返信する", label: "仕事", date: 1},
  {title: "洗濯機を回す", label: "家事", date: 1},
  {title: "税理士と打ち合わせ", label: "事業", date: 1, status: true},
  {title: "JavaScriptの勉強", label: "プログラミング", date: 1},
  {title: "PHPを勉強する", label: "プログラミング", date: 1},
  {title: "歯磨き粉を買う", label: "家事", date: 1, status: true},
  {title: "子供と公園に行く", label: "育児", date: 2, status: true},
  {title: "ゴミを捨てる", label: "家事", date: 2},
  {title: "カラオケに行く", label: "娯楽", date: 2, status: true},
  {title: "Progateをやる", label: "プログラミング", date: 2},
  {title: "ブログを書く", label: "事業", date: 2},
  {title: "合コンに参加", label: "娯楽", date: 2},
  {title: "中国語を勉強する", label: "自己投資", date: 3, status: true},
  {title: "HIITトレーニング", label: "スポーツ", date: 3},
  {title: "読書をする", label: "自己投資", date: 3},
  {title: "Pythonを勉強する", label: "プログラミング", date: 3},
  {title: "ドットインストールをやる", label: "プログラミング", date: 3},
  {title: "飲み会", label: "仕事", date: 3, status: true},
  {title: "子供と映画を見る", label: "育児", date: 3},
  {title: "博物館に行く", label: "娯楽", date: 4},
  {title: "Youtubeを見る", label: "娯楽", date: 4, status: true},
  {title: "オンライン英会話", label: "自己投資", date: 4},
  {title: "旅行の計画を立てる", label: "娯楽", date: 4, status: true},
  {title: "Qiitaを書く", label: "プログラミング", date: 4},
  {title: "カフェで仕事をする", label: "仕事", date: 4},
  {title: "合コンに参加", label: "娯楽", date: 4, status: true},
]

users.each do |user|
  for i in 1..todos.length do
    todo = todos[i-1]
    createTodo(user, todo[:title], todo[:label], todo[:date], todo[:status])
  end
end