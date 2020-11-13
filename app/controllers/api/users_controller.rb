class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  include SessionsHelper

  def current_user
    if user_id = cookies.signed[:user_id]
      current_user = User.find(user_id)
      current_user = {
        id: current_user.id,
        username: current_user.username,
        email: current_user.email,
        user_image: current_user.user_image.url,
        facebook_uid: current_user.facebook_uid,
        twitter_uid: current_user.twitter_uid,
        google_uid: current_user.google_uid,
        auto_generated_password: current_user.auto_generated_password,
        unconfirmed_email: current_user.unconfirmed_email
      }
    else
      current_user = nil
    end

    render json: current_user
  end

  def create
    user = User.new(user_params)
    if user.save
      user.send_activation_email
      puts 'メールが送信されました'
    else
      puts '入力に不備があります'
    end
    redirect_to '/login'
  end

  def update
    current_user = User.find(params[:id])
    current_user.update(sns_profile_image: nil) if user_params[:remove_user_image] == '1'

    new_email = user_params[:email]
    if new_email == current_user.email
      new_email = nil
      puts 'メールアドレスに変更はありません'
    elsif User.email_used?(new_email)
      new_email = nil
      puts 'このメールアドレスはすでに使われています'
    else
      current_user.set_unconfirmed_email(new_email)
    end

    current_user.update(user_params.except(:email, :unconfirmed_email))
  end

  def destroy
    current_user.destroy
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:id, :username, :password, :email, :password_confirmation, :user_image, :remove_user_image, :facebook_uid, :twitter_uid, :google_uid, :auto_generated_password, :unconfirmed_email)
  end
end
