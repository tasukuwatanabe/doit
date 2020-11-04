class Api::TodosController < ApplicationController
  protect_from_forgery except: %i[create update destroy toggle_status]

  include CalculationDateHelper
  # include CalculationMonthHelper

  # before_action :get_shortcuts
  # before_action :set_todo, only: %i[update destroy]

  def index
    selected_date = if params[:date]
                      Date.parse(params[:date])
                    else
                      Date.today
                    end

    todos = current_user.todos.where(todo_date: selected_date).order(created_at: :desc).select(:id, :title, :status, :start_date, :end_date, :continue_without_end, :history_display, :body, :label_id, :apply_days)

    labels = current_user.labels.order(created_at: :desc).all

    selected_date = selected_date
    selected_format_date = selected_date.strftime('%Y年%1m月%1d日')
    previous_date = selected_date.yesterday
    previous_format_date = selected_date.yesterday.strftime('%Y年%1m月%1d日')
    next_date = selected_date.tomorrow
    next_format_date = selected_date.tomorrow.strftime('%Y年%1m月%1d日')

    api_data = {
      todos: todos,
      labels: labels,
      selected_date: selected_date,
      selected_format_date: selected_format_date,
      previous_date: previous_date,
      previous_format_date: previous_format_date,
      next_date: next_date,
      next_format_date: next_format_date
    }

    render json: api_data
  end

  # def search
  #   todos = Todo.search(params[:search])
  # end

  def create
    start_date = Date.parse(todo_params[:start_date])
    end_date = Date.parse(todo_params[:end_date])
    todo_term = (end_date - start_date).to_i + 1

    todos = []

    begin
      Todo.transaction do
        todo_parent = TodoParent.create(user_id: current_user.id)
        todo_term.times do |n|
          todo = current_user.todos.build(todo_params)
          todo.todo_parent_id = todo_parent.id
          todo.todo_date = todo.start_date + n.days
          todo.save
          todos.push(todo)
        end
      end
      head :no_content
    rescue StandardError
      render json: { error: todos.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  def update
    start_date = Date.parse(todo_params[:start_date])
    end_date = Date.parse(todo_params[:end_date])
    todo_term = (end_date - start_date).to_i + 1

    todo = Todo.find_by(id: todo_params[:id])
    todos = Todo.where(todo_parent_id: todo.todo_parent_id)

    # begin
    # Todo.transaction do
    todos.each do |todo|
      todo.destroy if todo.todo_date < start_date || todo.todo_date > end_date
    end

    todo_term.times do |n|
      found_todo = Todo.find_by(
        todo_date: start_date + n.days,
        todo_parent_id: todo.todo_parent_id
      )
      if found_todo
        found_todo.update(todo_params.except(:id))
      else
        new_todo = current_user.todos.build(todo_params.except(:id))
        new_todo.todo_parent_id = todo.todo_parent_id
        new_todo.todo_date = start_date + n.days
        new_todo.save
      end
    end
    # end
    head :no_content
    # rescue StandardError
    #   render json: { error: todos.errors.full_messages.join(' ') }, status: :unprocessable_entity
    # end
  end

  def destroy
    todo = Todo.find_by(id: params[:id])
    puts todo.todo_parent_id
    puts todo.todo_parent_id
    puts todo.todo_parent_id
    puts todo.todo_parent_id
    todo_parent = TodoParent.find_by(id: todo.todo_parent_id)
    todo_parent.destroy
  end

  def toggle_status
    todo = Todo.find_by(id: params[:todo_id])
    todo.status = !todo.status
    todo.save
    head :no_content
  end

  # def history; end

  private

  # def set_todo
  #   todo = Todo.find(params[:id])
  # end

  def todo_params
    params.fetch(:todo, {}).permit(:id, :title, :status, :start_date, :end_date, :continue_without_end, :history_display, :body, :label_id, apply_days: [])
  end

  # def get_shortcuts
  #   shortcuts = Shortcut.where(user_id: current_user.id)
  # end
end
