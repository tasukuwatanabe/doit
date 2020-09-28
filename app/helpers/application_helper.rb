module ApplicationHelper
  def document_title
    if @title.present?
      "#{@title} | DoIT"
    else
      'DoIT'
    end
  end
end
