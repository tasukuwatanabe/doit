users = User.all

def createShortcut(user, title, label)
  shortcut = user.shortcuts.build(
    title: title,
    label_id: user.labels.find_by(title: label).id
  )
  shortcut.save
end

shortcuts = [
  { title: "掃除機をかける", label: "家事"},
  { title: "読書をする", label: "自己投資"},
  { title: "ジムに行く", label: "スポーツ"},
  { title: "JavaScriptの勉強", label: "プログラミング"},
  { title: "メールを返信する", label: "仕事"},
  { title: "JavaScriptの勉強", label: "プログラミング"},
  { title: "事業計画書をまとめる", label: "事業"},
  { title: "子供と公園に行く", label: "育児"},
]

users.each do |user|
  for i in 1..shortcuts.length do
    createShortcut(user, shortcuts[i-1][:title], shortcuts[i-1][:label])
  end
end