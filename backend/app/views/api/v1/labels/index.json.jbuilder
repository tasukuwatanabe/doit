json.array! @labels do |label|
  json.extract! label, :id, :created_at
  json.label_title label.title
  json.label_color label.color
  json.todo_count label.todos.size
end