class TasksController < ApplicationController
  before_action :logged_in_user
  before_action :get_shortcuts, only: :index

  def index
    @tasks = Task.where(user_id: @current_user.id, date_id: params[:date])
    @date_tasks = @tasks.where(date_id: get_url_date)
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
      if Rails.application.routes.recognize_path(request.referrer)[:controller] == 'tasks' && Rails.application.routes.recognize_path(request.referrer)[:action] == 'index'
        flash[:danger] = @task.errors.messages.values[0][0]
        redirect_back(fallback_location: root_path)
      else
        render action: 'new'
      end
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
      :title, :body, :status, :date_id
    )
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy!
    flash[:success] = 'ToDoが削除されました。'
    redirect_to request.referer
  end

  def toggle_status
    render body: nil
    @task = Task.find(params[:id])
    @task.status = !@task.status
    @task.save
  end
end
