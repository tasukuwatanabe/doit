require 'date'

class TopsController < ApplicationController
  before_action :logged_in_user
  before_action :get_shortcuts

  def dashboard
    if !date_valid?(params[:date])
      flash[:danger] = '日付が適切な値ではありません'
      redirect_to dashboard_path(@today)
    elsif date_out_of_range?
      one_year_from_today = 1.year.since(@today.to_date).strftime('%Y月%1m月%1d日')
      flash_message = '2000年1月1日〜' + one_year_from_today + 'までの日付を指定できます'
      flash[:danger] = flash_message
      redirect_to dashboard_path(@today)
    else
      @todos = Todo.where(user_id: @current_user.id, todo_date: get_url_date)
      @date_todos = @todos.where(todo_date: get_url_date)
    end
  end
end
