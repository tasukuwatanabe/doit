module Api
  module V1
    class TodosController < ApplicationController
      def index
        todos = current_user.todos
                            .where(todo_date: params[:date])
                            .left_joins(:labels)
                            .order(created_at: :desc)
                            .select('todos.id,
                                      todos.title,
                                      todos.status,
                                      todos.todo_date,
                                      todos.body,
                                      labels.id AS label_id,
                                      labels.title AS label_title,
                                      labels.color AS label_color')
                            
        render json: todos, status: 200
      end

      def create
        todo = current_user.todos.build(todo_params)
        if todo.save
          render json: todo, status: 200
        else
          errors = todo.errors.keys.map { |key| [key, todo.errors.full_messages_for(key)[0]] }.to_h
          render json: { errors: errors }, status: :unprocessable_entity
        end
      end

      def update
        todo = Todo.find(params[:id])
        if todo.update(todo_params)
          render json: todo, status: 200
        else
          errors = todo.errors.keys.map { |key| [key, todo.errors.full_messages_for(key)[0]] }.to_h
          render json: { errors: errors }, status: :unprocessable_entity
        end
      end

      def destroy
        todo = Todo.find(params[:id])
        todo.destroy
      end

      def toggle_status
        todo = Todo.find_by(id: params[:todo_id])
        todo.status = !todo.status
        todo.save
      end

      def search
        todos = current_user.todos.search(params[:query])
                                  .left_joins(:labels)
                                  .select('todos.id,
                                            todos.title,
                                            todos.todo_date,
                                            labels.title AS label_title,
                                            labels.color AS label_color')

        render json: todos, status: 200
      end

      private

      def todo_params
        params.require(:todo).permit(:id, :title, :status, :todo_date, :body, { label_ids: [] })
      end
    end
  end
end
