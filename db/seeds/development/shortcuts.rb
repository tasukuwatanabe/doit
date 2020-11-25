shortcuts = [
  { title: "掃除機をかける", label: "家事" },
  { title: "読書をする", label: "自己投資" },
  { title: "ジムに行く", label: "スポーツ" },
  { title: "JavaScriptの勉強", label: "プログラミング" },
  { title: "Rubyの勉強", label: "プログラミング" },
  { title: "メールを返信する", label: "仕事" },
  { title: "子供と公園に行く", label: "育児" },
  { title: "鬼滅の刃を観る", label: "娯楽" }
]

def getLabelId(user, title)
  Label.where(user_id: user.id, title: title)[0].id
end

def createShortcut(user, title, label)
  shortcut = user.shortcuts.build({
    title: title,
    label_ids: [label]
  })
  shortcut.save
end

users = User.all
users.each do |user|
  for i in 1..shortcuts.length do
    shortcut = shortcuts[i-1]
    createShortcut(user, shortcut[:title], getLabelId(user, shortcut[:label]))
  end
end