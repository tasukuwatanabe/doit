class Api::TodosController < ApplicationController
  skip_before_action :verify_authenticity_token

  include CalculationDateHelper

  def index
    todos = current_user.todos.where(todo_date: params[:date]).order(created_at: :desc).select(:id, :title, :status, :start_date, :end_date, :continue_without_end, :history_display, :body, :label_id, :apply_days)

    labels = current_user.labels.order(created_at: :desc).select(:id, :title, :color)
    todos.each do |todo|
      labels.select { |label| label.id == todo.label_id }
    end

    api_data = {
      todos: todos,
      labels: labels
    }

    render json: api_data
  end

  def create
    start_date = Date.parse(todo_params[:start_date])
    end_date = if todo_params[:continue_without_end]
                 1.year.since(Date.today)
               else
                 Date.parse(todo_params[:end_date])
               end
    todo_term = (end_date - start_date).to_i + 1
    apply_days = todo_params[:apply_days]

    # begin
    Todo.transaction do
      todo_parent = TodoParent.create(user_id: current_user.id)
      todo_term.times do |n|
        todo = current_user.todos.build(todo_params)
        todo_date = todo.start_date + n.days
        day = todo_date.wday

        next unless apply_days.include?(day)

        todo = current_user.todos.build(todo_params)
        todo.todo_parent_id = todo_parent.id
        todo.todo_date = todo_date
        todo.save
      end
    end
    head :no_content
    # rescue StandardError
    #   render json: todo.errors, status: :unprocessable_entity
    # end
  end

  def update
    start_date = Date.parse(todo_params[:start_date])
    end_date = if todo_params[:continue_without_end]
                 1.year.since(Date.today)
               else
                 Date.parse(todo_params[:end_date])
               end
    todo_term = (end_date - start_date).to_i + 1
    apply_days = todo_params[:apply_days]

    todo = current_user.todos.find(params[:id])
    todos = current_user.todos.where(todo_parent_id: todo.todo_parent_id)

    begin
      Todo.transaction do
        todos.each do |todo|
          todo.destroy if todo.todo_date < start_date || todo.todo_date > end_date
        end

        todo_term.times do |n|
          day = (todo.start_date + n.days).wday

          found_todo = Todo.find_by(
            todo_date: start_date + n.days,
            todo_parent_id: todo.todo_parent_id
          )

          if found_todo
            if apply_days.include?(day)
              found_todo.update(todo_params.except(:id))
            else
              found_todo.destroy
            end
          elsif apply_days.include?(day)
            new_todo = current_user.todos.build(todo_params.except(:id))
            new_todo.status = false
            new_todo.todo_parent_id = todo.todo_parent_id
            new_todo.todo_date = start_date + n.days
            new_todo.save
          end
        end
      end
      head :no_content
    rescue StandardError
      render json: todo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    todo = Todo.find_by(id: params[:id])
    todo_parent = TodoParent.find_by(id: todo.todo_parent_id)
    if todo_parent.destroy
      render json: 'deleted'
    else
      render json: todo.errors, status: :unprocessable_entity
    end
  end

  def toggle_status
    todo = Todo.find_by(id: params[:todo_id])
    todo.status = !todo.status
    todo.save
    head :no_content
  end

  private

  def todo_params
    params.fetch(:todo, {}).permit(:id, :title, :status, :start_date, :end_date, :continue_without_end, :history_display, :body, :label_id, apply_days: [])
  end
end
