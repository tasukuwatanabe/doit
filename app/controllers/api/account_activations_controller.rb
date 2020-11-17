class Api::AccountActivationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def edit
    user = User.find_by(email: params[:email])
    if user && user.activated?
      puts "アカウントはすでに有効です"
      # render json: { message: "アカウントはすでに有効です"}
      redirect_to '/'
    elsif user && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      puts "アカウントが有効化されました"
      # render json: { message: "アカウントが有効化されました"}
      redirect_to '/'
    else
      puts "有効化リンクが無効です"
      # render json: { message: "有効化リンクが無効です"}
      redirect_to '/signup'
    end
  end
end
