module Api
  module V1
    class AccountActivationsController < ApplicationController
      def edit
        user = User.find_by(email: params[:email])

        if user && user.activated?
          query = '?account_activation=already'
        elsif user && !user.activated? && user.authenticated?(:activation, params[:id])
          user.activate
          log_in user
          query = '?account_activation=activated'
        else
          query = '?account_activation=invalid'
        end

        redirect_to client_host + '/redirect' + query
      end
    end
  end
end