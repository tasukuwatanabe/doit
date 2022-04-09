module Api
  module V1
    class PasswordsController < ApplicationController
      def update
        user = User.find(params[:user_id])
        change_password_form = ChangePasswordForm.new(user, password_params)
        if change_password_form.save
          render json: { user: user, message: "パスワードが更新されました" }, status: 200
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
