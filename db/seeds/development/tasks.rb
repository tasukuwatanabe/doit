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
    title: (titles[n % titles.length]).to_s,
    body: n.even? ? 'メモを残すことができます' : nil,
    status: false,
    user_id: 1,
    date_id: (Date.today - (n / 5).days).to_s
  )
end
