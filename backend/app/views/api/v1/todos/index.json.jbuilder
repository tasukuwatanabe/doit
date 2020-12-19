json.array! @todos do |todo|
  json.extract! todo, :id, :title, :todo_date, :body, :status, :created_at
  if todo.labels.present?
    json.label_id todo.labels[0].id
    json.label_title todo.labels[0].title
    json.label_color todo.labels[0].color
  end
end