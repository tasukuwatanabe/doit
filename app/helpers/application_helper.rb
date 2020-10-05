module ApplicationHelper
  def default_meta_tags
    {
      site: 'DoIT',
      reverse: true,
      charset: 'utf-8',
      description: 'DoIT(ドゥーイット)はTodoを日単位で管理できるアプリです。ルーティーンを設定して、行動の習慣化に繋げましょう。',
      keywords: 'Todoリスト, スケジュール, 予定管理, 習慣化, 継続',
      canonical: request.original_url,
      separator: '|',
      icon: [
        { href: image_url('/favicon.ico') },
        { href: image_url('/apple-touch-icon.png'), rel: 'apple-touch-icon', sizes: '162x162', type: 'image/jpg' }
      ],
      og: {
        site_name: :site, # もしくは site_name: :site
        title: :title, # もしくは title: :title
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('/ogp.jpg'),
        locale: 'ja_JP'
      }
    }
  end
end
