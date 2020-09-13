class TasksController < ApplicationController
  def index
    @tasks = Task.where(date_id: params[:date])
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = 1
    if @task.save
      flash.notice = 'ToDoが追加されました。'
      redirect_to index_path(@task.date_id)
    else
      render action: 'index'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    @task.assign_attributes(task_params)
    if @task.save
      flash.notice = 'ToDoが更新されました。'
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
    flash.notice = 'ToDoが削除されました。'
    redirect_to :tasks
  end
end
