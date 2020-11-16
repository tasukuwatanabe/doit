class Api::LabelsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    labels = current_user.labels.order(created_at: :desc).select(:id, :title, :color)
    todos = current_user.todos.where.not(label_id: nil).select(:label_id)
    api_array = {
      labels: labels,
      todos: todos
    }
    render json: api_array
  end

  def create
    label = current_user.labels.build(label_params)
    if label.save
      head :no_content
    else
      errors = label.errors.keys.map { |key| [key, label.errors.full_messages_for(key)[0]] }.to_h
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def update
    label = Label.find(params[:id])
    if label.update(label_params)
      head :no_content
    else
      errors = label.errors.keys.map { |key| [key, label.errors.full_messages_for(key)[0]] }.to_h
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def destroy
    label = Label.find(params[:id])
    todos = Todo.where(label_id: label.id).update_all(label_id: nil)
    shortcuts = Shortcut.where(label_id: label.id).update_all(label_id: nil)
    label.destroy
  end

  private

  def label_params
    params.fetch(:label, {}).permit(:id, :title, :color)
  end
end
