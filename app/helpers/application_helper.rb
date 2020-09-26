module ApplicationHelper
  def document_title
    if @title.present?
      "#{@title} - ToDo App"
    else
      'ToDo App'
    end
  end
end
