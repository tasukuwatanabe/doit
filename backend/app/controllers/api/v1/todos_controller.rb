module Api
  module V1
    class TodosController < ApplicationController
      def index
        @todos = current_user.todos
                             .where(todo_date: params[:date])
                             .includes([:labels])
                             .order(created_at: :desc)
                            
        render 'index', formats: :json, handlers: 'jbuilder'
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
        todo = Todo.find(params[:todo_id])
        todo.status = !todo.status
        todo.save
        head :no_content
      end

      def search
        @todos = current_user.todos
                             .search(params[:query])
                             .includes([:labels])
        render 'index', formats: :json, handlers: 'jbuilder'
      end

      private

      def todo_params
        params.require(:todo).permit(:title, :status, :todo_date, :body, { label_ids: [] })
      end
    end
  end
end
