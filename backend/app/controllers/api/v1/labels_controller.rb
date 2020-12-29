module Api
  module V1
    class LabelsController < ApplicationController
      before_action :set_label, only: %i[update destroy]

      def index
        @labels = current_user.labels.recent
        render 'index', formats: :json, handlers: 'jbuilder'
      end

      def create
        label = current_user.labels.build(label_params)
        if label.save
          head :created
        else
          render json: { errors: format_errors(label) }, status: :unprocessable_entity
        end
      end

      def update
        if @label.update(label_params)
          head :ok
        else
          render json: { errors: format_errors(@label) }, status: :unprocessable_entity
        end
      end

      def destroy
        @label.destroy!
        head :ok
      end

      private

      def set_label
        @label = Label.find(params[:id])
      end

      def label_params
        params.require(:label).permit(:title, :color)
      end
    end
  end
end
