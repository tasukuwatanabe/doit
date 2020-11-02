class Api::TodosController < ApplicationController
  # protect_from_forgery except: %i[create update destroy]

  # include CalculationDateHelper
  # include CalculationMonthHelper

  # before_action :get_shortcuts
  # before_action :set_todo, only: %i[update destroy]

  def index
    todos = current_user.todos.order(created_at: :desc).all
    render json: todos
  end

  # def search
  #   todos = Todo.search(params[:search])
  # end

  # def create
  #   start_date = Date.parse(todo_params[:start_date])
  #   end_date = Date.parse(todo_params[:end_date])

  #   todos = []
  #   todo_parent = TodoParent.create(user_id: current_user.id)

  #   todo_term = (end_date - start_date).to_i + 1
  #   todo_term.times do |n|
  #     todo = current_user.todos.build(todo_params)
  #     todo.todo_parent_id = todo_parent.id
  #     todo.todo_date = todo.start_date + n.days
  #     todos.push(todo) if todo.apply_days.include?(todo.todo_date.wday)
  #   end

  #   begin
  #     Todo.transaction do
  #       todos.each do |todo|
  #         todo.save!
  #       end
  #     end
  #     flash[:success] = 'ToDoが追加されました'
  #     redirect_to root_path(todos[0].start_date)
  #   rescue StandardError
  #     flash[:danger] = 'ToDoの作成に失敗しました'
  #     redirect_to root_path(todos[0].start_date)
  #   end
  # end

  # def update
  #   todo.assign_attributes(todo_params)

  #   begin
  #     Todo.transaction do
  #       todos.each do |todo|
  #         todo.save!
  #       end
  #     end
  #   rescue StandardError
  #   end
  # end

  # def destroy
  #   todo_parent = TodoParent.find(todo.todo_parent_id)
  #   todo_parent.destroy
  # end

  # def toggle_status
  #   render body: nil
  #   todo = Todo.find(params[:todo_id])
  #   todo.status = !todo.status
  #   todo.save
  # end

  # def history; end

  # private

  # def set_todo
  #   todo = Todo.find(params[:id])
  # end

  # def todo_params
  #   params.fetch(:todo, {}).permit(:id, :title, :status, :start_date, :end_date, :continue_without_end, :history_display, :body, :label_id, apply_days: [])
  # end

  # def get_shortcuts
  #   shortcuts = Shortcut.where(user_id: current_user.id)
  # end
end
