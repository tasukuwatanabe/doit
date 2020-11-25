titles = %w[自己投資 家事 娯楽 仕事 プログラミング スポーツ 事業 育児]
colors = %w[#F44E3B #FE9200 #DBDF00 #68CCCA #AEA1FF #FDA1FF #C45100 #999999]

users = User.all
users.each do |user|
  for i in 1..titles.length do
    label = user.labels.build(
      title: titles[i-1],
      color: colors[i-1]
    )
    label.save
  end
end