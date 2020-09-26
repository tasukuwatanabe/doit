class TodosController < ApplicationController
  before_action :logged_in_user
  before_action :get_shortcuts, only: :index

  def index
    @todos = Todo.where(user_id: @current_user.id, todo_date: params[:date])
    @date_todos = @todos.where(todo_date: get_url_date)
  end

  def show
    @todo = Todo.find(params[:id])
  end

  def new
    @todo = Todo.new
  end

  def create
    end_date = Date.parse(todo_params[:end_date])
    start_date = Date.parse(todo_params[:start_date])
    todo_terms = (end_date - start_date).to_i + 1

    @routine = current_user.routines.build

    begin
      todo_terms.times do |n|
        @todo = current_user.todos.build(todo_params)
        @todo.todo_date = start_date + n.days
        @todo.routine_id = @routine.id
        @todo.save!
      end
    rescue StandardError
      render action: 'new'
    else
      flash[:success] = 'ToDoが追加されました。'
      redirect_to index_path(@todo.start_date)
    end
  end

  def edit
    @todo = Todo.find(params[:id])
  end

  def update
    @todo = Todo.find(params[:id])
    @todo.assign_attributes(todo_params)
    if @todo.save
      flash[:success] = 'ToDoが更新されました。'
      redirect_to index_path(@todo.todo_date)
    else
      render action: 'edit'
    end
  end

  def destroy
    todo = Todo.find(params[:id])
    todo.destroy!
    flash[:success] = 'ToDoが削除されました。'
    redirect_to request.referer
  end

  def toggle_status
    render body: nil
    @todo = Todo.find(params[:id])
    @todo.status = !@todo.status
    @todo.save
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :body, :status, :todo_date, :start_date, :end_date)
  end
end
