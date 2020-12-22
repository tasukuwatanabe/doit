module Api
  module V1
    class AccountActivationsController < ApplicationController
      def edit
        user = User.find_by(email: params[:email])
        redirect_query = generate_query(user)
        activate_user(user)
        redirect_to client_host + '/redirect' + redirect_query
      end

      private

      def activate_user(user)
        if !user.activated? && user.authenticated?(:activation, params[:id])
          user.activate
          log_in user
        end
      end

      def generate_query(user)
        query = 'invalid'
        query = 'already' if user.activated?
        query = 'activated' if !user.activated? && user.authenticated?(:activation, params[:id])
        "?account_activation=#{query}"
      end
    end
  end
end