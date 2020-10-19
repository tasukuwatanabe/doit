module ErrorMessageHelper
  def error_message(model, attribute)
    if model.errors.include?(attribute)
      "<div class='error-message'>#{model.errors.full_messages_for(attribute).first}</div>".html_safe
    end
  end
end
