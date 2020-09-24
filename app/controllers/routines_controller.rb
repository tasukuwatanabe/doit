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
        todo = current_user.todos.build(routine_id: @routine.id, title: @routine.title, body: @routine.body)
        todo.date_id = @routine.start_date + n
        todo.save
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
      todos = current_user.todos.where(routine_id: @routine.id)
      todos.each do |todo|
        todo.update_attributes(title: @routine.title)
        todo.save
      end
      flash[:success] = 'ルーティーンを更新しました。'
      redirect_to routines_path
    else
      render action: 'new'
    end
  end

  def destroy
    @routine = Routine.find(params[:id])
    todos = current_user.todos.where(routine_id: @routine.id)
    todos.destroy_all
    @routine.destroy
    flash[:success] = 'ルーティーンを削除しました。'
    redirect_to routines_path
  end

  private def routine_params
    params.require(:routine).permit(:title, :body, :start_date, :end_date)
  end
end
