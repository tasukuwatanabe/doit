module Api
  module V1
    class LabelsController < ApplicationController
      def index
        @labels = current_user.labels
                              .order(created_at: :desc)

        render 'index', formats: :json, handlers: 'jbuilder'
      end

      def create
        label = current_user.labels.build(label_params)
        if label.save
          head :no_content
        else
          render json: { errors: format_errors(label) }, status: :unprocessable_entity
        end
      end

      def update
        label = Label.find(params[:id])
        if label.update(label_params)
          head :no_content
        else
          render json: { errors: format_errors(label) }, status: :unprocessable_entity
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
