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

10.times do |n|
  Task.create!(
    title: (titles[n]).to_s,
    body: n.even? ? 'メモを残すことができます' : nil,
    status: n % 3 != 0 ? n % 3 : 1,
    user_id: n.odd? ? n % 2 : 2
  )
end
