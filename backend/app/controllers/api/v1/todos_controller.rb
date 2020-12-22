module Api
  module V1
    class TodosController < ApplicationController
      before_action :set_todo, only: %i[update destroy]

      def index
        @todos = current_user.todos.match_date(params[:date])
        render 'index', formats: :json, handlers: 'jbuilder'
      end

      def create
        todo = current_user.todos.build(todo_params)
        unless todo.save
          render json: { errors: format_errors(todo) }, status: :unprocessable_entity
        end
      end

      def update
        unless @todo.update(todo_params)
          render json: { errors: format_errors(@todo) }, status: :unprocessable_entity
        end
      end

      def destroy
        @todo.destroy
      end

      def toggle_status
        todo = Todo.find(params[:todo_id])
        todo.status = !todo.status
        todo.save!
      end

      def search
        @todos = current_user.todos.search(params[:search_query])
        render 'index', formats: :json, handlers: 'jbuilder'
      end

      private

      def set_todo
        @todo = Todo.find(params[:id])
      end

      def todo_params
        params.require(:todo).permit(:title, :status, :todo_date, :body, { label_ids: [] })
      end
    end
  end
end
