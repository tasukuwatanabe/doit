module Api
  module V1
    class LabelsController < ApplicationController
      before_action :set_label, only: %i[update destroy]

      def index
        @labels = current_user.labels.order_created_desc
        render 'index', formats: :json, handlers: 'jbuilder'
      end

      def create
        label = current_user.labels.build(label_params)
        unless label.save
          render json: { errors: format_errors(label) }, status: :unprocessable_entity
        end
      end

      def update
        unless @label.update(label_params)
          render json: { errors: format_errors(@label) }, status: :unprocessable_entity
        end
      end

      def destroy
        @label.destroy
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
