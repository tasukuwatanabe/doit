module Api
  module V1
    class LabelsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def index
        labels = current_user.labels
                              .left_joins(:todos)
                              .group(:id)
                              .order(created_at: :desc)
                              .select('labels.id, labels.title, color, COUNT(todos.id) AS todo_count')
        render json: labels, status: 200
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
        label.destroy
      end

      private

      def label_params
        params.require(:label).permit(:id, :title, :color)
      end
    end
  end
end
