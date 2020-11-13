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
        user_image: current_user.user_image.url
      }
    else
      current_user = nil
    end

    render json: current_user
  end

  def create
    @user = User.new(user_params)
    @user.send_activation_email
  end

  def update
    current_user.update(sns_profile_image: nil) if params[:user][:remove_user_image] == '1'
    current_user.set_unconfirmed_email(@new_email) if @new_email
  end

  def destroy
    current_user.destroy
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:id, :username, :password, :email, :password_confirmation, :user_image, :remove_user_image)
  end
end
