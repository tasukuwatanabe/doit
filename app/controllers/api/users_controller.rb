class Api::UsersController < ApplicationController
  def current_user
    current_user = User.where(id: session[:user_id]).select(:id, :username, :email)
    render json: { state: 'success', user: { id: user.id, username: user.username, email: user.email } }, status: 200
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

  def cancel_oauth
    uid_type = params[:uid_type]
    current_user.cancel_oauth(uid_type)
    flash[:success] = '連携を解除しました'
    redirect_to current_user
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:id, :username, :password, :email, :password_confirmation, :user_image, :remove_user_image)
  end
end
