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
  親に電話をかける
]

50.times do |n|
  Task.create!(
    title: (titles[n]).to_s,
    body: n.even? ? 'メモを残すことができます' : nil,
    status: n % 3 != 0 ? 'uncompleted' : 'completed',
    user_id: n % 3 != 0 ? n % 3 : 1,
    date_id: (Date.today - n.days).to_s
  )
end
