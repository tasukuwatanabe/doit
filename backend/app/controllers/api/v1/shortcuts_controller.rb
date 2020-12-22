module Api
  module V1
    class ShortcutsController < ApplicationController
      before_action :set_shortcut, only: %i[update destroy]

      def index
        @shortcuts = current_user.shortcuts
                                 .include_labels
                                 .order_created_desc
        render 'index', formats: :json, handlers: 'jbuilder'
      end

      def create
        shortcut = current_user.shortcuts.build(shortcut_params)
        if shortcut.save
          head :no_content
        else
          render json: { errors: format_errors(shortcut) }, status: :unprocessable_entity
        end
      end

      def update
        unless @shortcut.update(shortcut_params)
          render json: { errors: format_errors(@shortcut) }, status: :unprocessable_entity
        end
      end

      def destroy
        @shortcut.destroy
      end

      private

      def set_shortcut
        @shortcut = Shortcut.find(params[:id])
      end

      def shortcut_params
        params.require(:shortcut).permit(:title, { label_ids: []})
      end
    end
  end
end
