titles = %w[
  PHPを勉強する
  Rubyを勉強する
  Pythonを勉強する
  Goを勉強する
  JavaScriptを勉強する
  散歩する
  新聞を読む
  読書をする
  Youtubeを観る
  子供と遊ぶ
  テレビを観る
]

titles.each do |title|
  Shortcut.create!(
    title: title,
    body: '頑張って取り組もう！',
    user_id: User.find_by(email: 'testuser1@example.com').id
  )
end
