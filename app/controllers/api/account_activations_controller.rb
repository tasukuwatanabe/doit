class Api::AccountActivationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def edit
    user = User.find_by(email: params[:email])
    if user && user.activated?
      puts 'アカウントはすでに有効です'
    elsif user && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      puts 'アカウントが有効化されました'
    else
      puts '有効化リンクが無効です'
    end

    redirect_to root_path
  end
end
