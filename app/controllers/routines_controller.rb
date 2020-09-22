class RoutinesController < ApplicationController
  def index
    @routines = current_user.routines.all
  end

  def new
    @routine = Routine.new
  end

  def create
    @routine = current_user.routines.build(routine_params)
    if @routine.save
      routine_days = (@routine.end_date - @routine.start_date).to_i + 1
      routine_days.times do |n|
        task = current_user.tasks.build(routine_id: @routine.id, title: @routine.title, body: @routine.body)
        task.date_id = @routine.start_date + n
        task.save
      end
      flash[:success] = 'ルーティーンを作成しました。'
      redirect_to routines_path
    else
      render action: 'new'
    end
  end

  def edit
    @routine = Routine.find(params[:id])
  end

  def update
    @routine = Routine.find(params[:id])
    @routine.assign_attributes(routine_params)
    if @routine.save
      tasks = current_user.tasks.where(routine_id: @routine.id)
      tasks.each do |task|
        task.update_attributes(title: @routine.title)
        task.save
      end
      flash[:success] = 'ルーティーンを更新しました。'
      redirect_to routines_path
    else
      render action: 'new'
    end
  end

  def destroy
    @routine = Routine.find(params[:id])
    tasks = current_user.tasks.where(routine_id: @routine.id)
    tasks.destroy_all
    @routine.destroy
    flash[:success] = 'ルーティーンを削除しました。'
    redirect_to routines_path
  end

  private def routine_params
    params.require(:routine).permit(:title, :body, :start_date, :end_date)
  end
end
