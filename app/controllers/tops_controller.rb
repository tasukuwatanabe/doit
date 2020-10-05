class TopsController < ApplicationController
  include CalculationDateHelper

  before_action :logged_in_user
  before_action :get_shortcuts

  def home
    redirect_to index_path(@today)
  end

  def index
    set_meta_tags title: 'ダッシュボード'
    params_array = params[:date].split('-').map(&:to_i)
    if params_array.count < 3 || params_array.include?(0)
      raise StandardError
    end

    Date.parse(params[:date])
  rescue StandardError
    flash[:danger] = '日付が適切な値ではありません'
    redirect_to index_path(@today)
  else
    if date_out_of_range?(get_url_date)
      one_year_from_today = 1.year.since(@today.to_date).strftime('%Y月%1m月%1d日')
      flash_message = '2000年1月1日〜' + one_year_from_today + 'までの日付を指定してください'
      flash[:danger] = flash_message
      redirect_to index_path(@today)
    else
      @todos = Todo.where(user_id: @current_user.id, todo_date: get_url_date)
      @date_todos = @todos.where(todo_date: get_url_date)
    end
  end

  private

  def get_shortcuts
    @shortcuts = Shortcut.where(user_id: current_user.id)
  end
end
