class TasksController < ApplicationController
  before_action :logged_in_user

  def index
    @tasks = Task.where(user_id: session[:user_id], date_id: params[:date])
    @date_tasks = @tasks.where(date_id: Date.parse(request.path.gsub('/', '')))
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'ToDoが追加されました。'
      redirect_to index_path(@task.date_id)
    else
      render action: 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    @task.assign_attributes(task_params)
    if @task.save
      flash[:success] = 'ToDoが更新されました。'
      redirect_to index_path(@task.date_id)
    else
      render action: 'edit'
    end
  end

  private def task_params
    params.require(:task).permit(
      :title, :body, :status, :limit_at, :user_id, :date_id
    )
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy!
    flash[:success] = 'ToDoが削除されました。'
    redirect_to request.referer
  end
end
