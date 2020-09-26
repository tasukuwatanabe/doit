require 'date'

module DateCalculationHelper
  def format_todo_date(todo_date)
    todo_date.strftime('%Y年%1m月%1d日')
  end

  def get_url_date
    request.path.gsub('/dates/', '').to_date
  end

  def get_formatted_url_date
    get_url_date.strftime('%Y年%1m月%1d日')
  end

  def set_previous_date
    get_url_date.yesterday
  end

  def set_next_date
    get_url_date.tomorrow
  end
end
