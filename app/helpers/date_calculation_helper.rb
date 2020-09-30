require 'date'

module DateCalculationHelper
  def date_valid?(date)
    Date.strptime(date, '%Y-%m-%d')
  rescue StandardError
    false
  end

  def date_out_of_range?
    get_url_date < Date.new(2000, 1, 1) || get_url_date > 1.year.from_now.to_date
  end

  def get_url_date
    Date.parse(params[:date])
  end

  def format_todo_date(todo_date)
    todo_date.strftime('%Y年%1m月%1d日')
  end

  def get_url_date_in_japanese
    get_url_date.strftime('%Y年%1m月%1d日')
  end

  def set_previous_date
    get_url_date.yesterday
  end

  def set_next_date
    get_url_date.tomorrow
  end
end
