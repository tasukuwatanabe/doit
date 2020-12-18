json.array! @shortcuts do |shortcut|
  json.extract! shortcut, :id, :title, :created_at
  json.label_id shortcut.labels[0].id
  json.label_title shortcut.labels[0].title
  json.label_color shortcut.labels[0].color
end