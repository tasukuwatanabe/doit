module Api
  module V1
    class PasswordsController < ApplicationController
      def update
        change_password_form = ChangePasswordForm.new(current_user, password_params)
        if change_password_form.save
          render json: current_user, status: 200
        else
          render json: { errors: format_errors(change_password_form) }, status: :unprocessable_entity
        end
      end

      private def password_params
        params.require(:change_password_form).permit(:password, :password_confirmation)
      end
    end
  end
end
