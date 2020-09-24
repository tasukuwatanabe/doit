class TodosController < ApplicationController
  before_action :logged_in_user
  before_action :get_shortcuts, only: :index

  def index
    @todos = Todo.where(user_id: @current_user.id, date_id: params[:date])
    @date_todos = @todos.where(date_id: get_url_date)
  end

  def show
    @todo = Todo.find(params[:id])
  end

  def new
    @todo = Todo.new
  end

  def create
    @todo = current_user.todos.build(todo_params)
    if @todo.save
      flash[:success] = 'ToDoが追加されました。'
      redirect_to index_path(@todo.date_id)
    else
      if Rails.application.routes.recognize_path(request.referrer)[:controller] == 'todos' && Rails.application.routes.recognize_path(request.referrer)[:action] == 'index'
        flash[:danger] = @todo.errors.messages.values[0][0]
        redirect_back(fallback_location: root_path)
      else
        render action: 'new'
      end
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
      redirect_to index_path(@todo.date_id)
    else
      render action: 'edit'
    end
  end

  private def todo_params
    params.require(:todo).permit(
      :title, :body, :status, :date_id
    )
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
end
