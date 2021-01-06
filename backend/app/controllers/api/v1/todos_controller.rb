module Api
  module V1
    class TodosController < ApplicationController
      before_action :set_todo, only: %i[update destroy]

      def index
        @todos = current_user.todos
                             .include_labels
                             .search(params[:search_query])
                             .match_date(params[:date])
                             .order_date_and_time_asc

        render 'index', formats: :json, handlers: 'jbuilder'
      end

      def create
        todo = current_user.todos.build(todo_params)
        if todo.save
          head :created
        else
          render json: { errors: format_errors(todo) }, status: :unprocessable_entity
        end
      end

      def update
        if @todo.update(todo_params)
          head :ok
        else
          render json: { errors: format_errors(@todo) }, status: :unprocessable_entity
        end
      end

      def destroy
        if @todo.destroy
          head :ok
        else
          head :internal_server_error
        end
      end

      def toggle_status
        todo = Todo.find(params[:todo_id])
        todo.status = !todo.status
        todo.save!
        head :ok
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
