class RoutinesController < ApplicationController
  before_action :logged_in_user
  before_action :set_routine, only: [ :show, :edit, :update, :destroy ]

  def index
    @routines = current_user.routines.all
  end

  def new
    @routine = Routine.new
    @routine.start_date ||= @today
    @routine.end_date ||= Date.parse(@today).tomorrow
  end

  def create
    @routine = current_user.routines.build(routine_params)
    if @routine.save
      routine_days = (@routine.end_date - @routine.start_date).to_i + 1
      routine_days.times do |n|
        todo = @routine.todos.build(routine_id: @routine.id, title: @routine.title, body: @routine.body, user_id: current_user.id)
        todo.todo_date = @routine.start_date + n.days
        todo.save!
      end
      flash[:success] = 'ルーティーンを作成しました。'
      redirect_to routines_path
    else
      render action: 'new'
    end
  end

  def edit; end

  def update
    @routine.assign_attributes(routine_params)

    if @routine.save
      @routine.todos.each do |todo|
        if todo.todo_date < @routine.start_date ||
           todo.todo_date > @routine.end_date
          todo.destroy
        end
      end

      routine_days = (@routine.end_date - @routine.start_date).to_i + 1
      routine_days.times do |n|
        todo_date = @routine.start_date + n.days
        todo = @routine.todos.find_by(todo_date: todo_date)
        if todo
          todo.update(title: @routine.title)
        else
          todo = @routine.todos.build(title: @routine.title, body: @routine.body, user_id: current_user.id)
          todo.todo_date = todo_date
          todo.save!
        end
      end

      flash[:success] = 'ルーティーンを更新しました。'
      redirect_to routines_path
    else
      render action: 'new'
    end
  end

  def destroy
    todos = current_user.todos.where(routine_id: @routine.id)
    todos.destroy_all
    @routine.destroy
    flash[:success] = 'ルーティーンを削除しました。'
    redirect_to routines_path
  end

  def history
    @routines = current_user.routines.all
  end

  private

  def set_routine
    @routine = Routine.find(params[:id])
  end

  def routine_params
    params.require(:routine).permit(:title, :body, :start_date, :end_date)
  end
end
