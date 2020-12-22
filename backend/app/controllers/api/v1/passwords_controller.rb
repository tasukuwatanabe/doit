module Api
  module V1
    class PasswordsController < ApplicationController
      def update
        change_password_form = ChangePasswordForm.new(password_params)
        change_password_form.object = current_user
        change_password_form.object.auto_generated_password = nil
        if change_password_form.save
          render json: { message: "パスワードが更新されました"}, status: 200
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
