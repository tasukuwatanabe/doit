module Api
  module V1
    class ShortcutsController < ApplicationController
      def index
        @shortcuts = current_user.shortcuts
                                 .includes([:labels])
                                 .order(created_at: :desc)
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
        shortcut = Shortcut.find(params[:id])
        if shortcut.update(shortcut_params)
          head :no_content
        else
          render json: { errors: format_errors(shortcut) }, status: :unprocessable_entity
        end
      end

      def destroy
        shortcut = Shortcut.find(params[:id])
        shortcut.destroy
        head :no_content
      end

      private

      def shortcut_params
        params.require(:shortcut).permit(:id, :title, { label_ids: []})
      end
    end
  end
end
