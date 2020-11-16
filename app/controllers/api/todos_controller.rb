class Api::TodosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    todos = current_user.todos.where(todo_date: params[:date]).order(created_at: :desc).select(:id, :title, :status, :todo_date, :body, :label_id)
    labels = current_user.labels.select(:id, :title, :color)

    api_data = {
      todos: todos,
      labels: labels
    }

    render json: api_data
  end

  def create
    todo = current_user.todos.build(todo_params)
    if todo.save
      head :no_content
    else
      errors = todo.errors.keys.map { |key| [key, todo.errors.full_messages_for(key)[0]] }.to_h
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def update
    todo = Todo.find(params[:id])
    if todo.update(todo_params)
      head :no_content
    else
      errors = todo.errors.keys.map { |key| [key, todo.errors.full_messages_for(key)[0]] }.to_h
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def destroy
    todo = Todo.find(params[:id])
    todo.destroy
    head :no_content
  end

  def toggle_status
    todo = Todo.find_by(id: params[:todo_id])
    todo.status = !todo.status
    todo.save
    head :no_content
  end

  private

  def todo_params
    params.fetch(:todo, {}).permit(:id, :title, :status, :todo_date, :body, :label_id)
  end
end
