module Api
  module V1
    class UsersController < ApplicationController
      before_action :check_email, only: [:create, :update]

      def current
        @current_user = if user_id = cookies.signed[:user_id]
                          User.find(user_id)
                        end
        render 'current', formats: :json, handlers: 'jbuilder'
      end

      def create
        user = User.new(user_params)
        if user.save
          user.send_activation_email
          render json: { message: "アカウント認証用のメールが送信されました" }
        else
          errors = user.errors.keys.map { |key| [key, user.errors.full_messages_for(key)[0]] }.to_h
          render json: { errors: errors }, status: :unprocessable_entity
        end
      end

      def update
        user_form = UserForm.new(User.find(params[:id]), user_params)
        if user_form.save
          UserMailer.email_confirmation(user_form.user).deliver_now if user_form.changed_email
          render json: { user: user_form.user, message: "ユーザー情報が更新されました" }
        else
          errors = user_form.errors.map { |key, _v| [key, user_form.errors.full_messages_for(key)] }.to_h
          render json: { errors: errors }, status: :unprocessable_entity
        end
      end

      def destroy
        user = User.find(params[:id])
        user.destroy
        destroy_cookie
        render json: { message: "ユーザーが削除されました" }
      end

      private

      def user_params
        params.require(:user).permit(:username, :password, :email, :password_confirmation, :user_image, :remove_user_image, :facebook_uid, :twitter_uid, :google_uid, :auto_generated_password, :unconfirmed_email)
      end

      def check_email
        if user_params[:email] == 'guest@example.com'
          render json: { errors: { email: "このメールアドレスは使用できません。"} }, status: :unprocessable_entity
        end
      end
    end
  end
end
