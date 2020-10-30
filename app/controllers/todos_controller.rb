class TodosController < ApplicationController
  include CalculationDateHelper

  before_action :get_shortcuts
  before_action :set_todo, only: %i[edit update destroy]

  def index
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
      @date_todos = @todos.where(todo_date: get_url_date)
    end
  end

  def search
    @todos = Todo.search(params[:search])
  end

  def new
    @todo = Todo.new
    @todo.todo_date = @todo.todo_date || @today
  end

  def create
    @todo = current_user.todos.build(todo_params)
    if @todo.save
      flash[:success] = 'ToDoが追加されました。'
      redirect_to todo_index_path(@todo.todo_date)
    else
      render action: 'new'
    end
  end

  def show
    redirect_to edit_todo_path(params[:id])
  end

  def edit
    set_meta_tags title: 'Todoの編集'
  end

  def update
    @todo.assign_attributes(todo_params)
    if @todo.save
      flash[:success] = 'ToDoが更新されました。'
      redirect_to todo_index_path(@todo.todo_date)
    else
      render action: 'edit'
    end
  end

  def destroy
    @todo.destroy
    flash[:success] = 'ToDoを削除しました'
    redirect_to request.referer
  end

  def toggle_status
    render body: nil
    @todo = Todo.find(params[:todo_id])
    @todo.status = !@todo.status
    @todo.save
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :body, :status, :todo_date)
  end

  def get_shortcuts
    @shortcuts = Shortcut.where(user_id: current_user.id)
  end
end
