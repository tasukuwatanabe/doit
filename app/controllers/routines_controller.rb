class RoutinesController < ApplicationController
  include CalculationDateHelper
  include CalculationMonthHelper

  before_action :logged_in_user
  before_action :set_routine, only: [ :edit, :update, :destroy ]

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
        todo = @routine.todos.build(routine_id: @routine.id, title: @routine.title, user_id: current_user.id)
        todo.todo_date = @routine.start_date + n.days
        todo.save!
      end
      flash[:success] = 'ルーティーンを作成しました。'
      redirect_to routines_path
    else
      render action: 'new'
    end
  end

  def show
    redirect_to edit_routine_path(params[:id])
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
          todo = @routine.todos.build(title: @routine.title, user_id: current_user.id)
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
    params_array = params[:month].split('-').map(&:to_i)
    begin
      if params_array.count < 2 || !(1..12).cover?(params_array[1])
        raise StandardError
      end
    rescue StandardError
      flash[:danger] = 'URLに不適切な値が使われています'
      redirect_to history_path(set_this_month)
    else
      @year = params_array[0]
      @month = params_array[1]
      url_month = Date.new(@year, @month, 1)

      if month_out_of_range?(url_month)
        flash[:danger] = '対象外の期間が設定されています'
        redirect_to history_path(set_this_month)
      else
        @month_days = Date.new(@year, @month, 1).end_of_month.day.to_i
        @routines = current_user.routines.all
      end
    end
  end

  private

  def set_routine
    @routine = Routine.find(params[:id])
  end

  def routine_params
    params.require(:routine).permit(:title, :start_date, :end_date)
  end
end
