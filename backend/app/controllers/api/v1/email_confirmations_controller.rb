module Api
  module V1
    class EmailConfirmationsController < ApplicationController
      before_action :check_expiration, only: [:edit]

      def edit
        if @user.authenticated?(:confirmation, params[:id])
          @user.update_new_email
          log_out
          query = '?email_confirmed=true'
        else
          query = '?email_confirmed=false'
        end

        redirect_to host + '/redirect' + query
      end

      def destroy
        user = User.find(params[:id])
        if user && user.update(confirmation_digest: nil, unconfirmed_email: nil)
          render json: { message: "メールアドレスの更新がキャンセルされました"}
        else
          errors = user.errors.keys.map { |key| [key, user.errors.full_messages_for(key)[0]] }.to_h
          render json: { errors: errors }, status: :unprocessable_entity
        end
      end

      private

      def check_expiration
        @user = User.find_by(email: params[:email])
        if @user && @user.expired?(:confirmation)
          @user.update(confirmation_digest: nil, unconfirmed_email: nil)

          redirect_to host + '/redirect?email_confirmed=expired'
        end
      end
    end
  end
end
