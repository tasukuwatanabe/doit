class TodosController < ApplicationController
  include CalculationDateHelper
  include CalculationMonthHelper

  before_action :get_shortcuts
  before_action :set_todo, only: %i[update destroy]

  def index
    @todo = Todo.new
    @todo.todo_date = @todo.todo_date || @today
    @days = %w[日 月 火 水 木 金 土]

    params_array = params[:date].split('-').map(&:to_i)
    raise StandardError if params_array.count < 3 || params_array.include?(0)

    Date.parse(params[:date])
  rescue StandardError
    flash[:danger] = '日付が適切な値ではありません'
    redirect_to todo_index_path(@today)
  else
    if date_out_of_range?(get_url_date)
      one_year_from_today = 1.year.since(@today.to_date).strftime('%Y月%1m月%1d日')
      flash_message = '2000年1月1日〜' + one_year_from_today + 'までの日付を指定してください'
      flash[:danger] = flash_message
      redirect_to todo_index_path(@today)
    else
      @todos = Todo.where(user_id: @current_user.id, todo_date: get_url_date).order(created_at: :asc)
    end
  end

  def search
    @todos = Todo.search(params[:search])
  end

  def create
    start_date = Date.parse(todo_params[:start_date])
    end_date = Date.parse(todo_params[:end_date])

    todos = []
    todo_parent = TodoParent.create(user_id: current_user.id)

    todo_term = (end_date - start_date).to_i + 1
    todo_term.times do |n|
      todo = current_user.todos.build(todo_params)
      todo.todo_parent_id = todo_parent.id
      todo.todo_date = todo.start_date + n.days
      todos.push(todo) if todo.apply_days.include?(todo.todo_date.wday)
    end

    begin
      Todo.transaction do
        todos.each do |todo|
          todo.save!
        end
      end
      flash[:success] = 'ToDoが追加されました'
      redirect_to todo_index_path(todos[0].start_date)
    rescue StandardError
      flash[:danger] = 'ToDoの作成に失敗しました'
      redirect_to todo_index_path(todos[0].start_date)
    end
  end

  def update
    @todo.assign_attributes(todo_params)

    begin
      Todo.transaction do
        todos.each do |todo|
          todo.save!
        end
      end
      flash[:success] = 'ToDoが更新されました。'
      redirect_to todo_index_path(todos[0].start_date)
    rescue StandardError
      flash[:danger] = 'ToDoの更新に失敗しました'
      redirect_to todo_index_path(todos[0].start_date)
    end
  end

  def destroy
    @todo_parent = TodoParent.find(@todo.todo_parent_id)
    @todo_parent.destroy
    flash[:success] = 'ToDoを削除しました'
    redirect_to request.referer
  end

  def toggle_status
    render body: nil
    @todo = Todo.find(params[:todo_id])
    @todo.status = !@todo.status
    @todo.save
  end

  def history; end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :status, :start_date, :end_date, :continue_without_end, :history_display, :body, :label_id, apply_days: [])
  end

  def get_shortcuts
    @shortcuts = Shortcut.where(user_id: current_user.id)
  end
end
