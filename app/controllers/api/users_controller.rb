class Api::UsersController < ApplicationController
  # skip_before_action :logged_in_user, only: %i[new create]
  # before_action :forbid_guest_user, only: :destroy
  # before_action :forbid_login_user, only: %i[new create]
  # before_action :correct_user, only: %i[edit update]
  # before_action :validate_email_update, only: :update

  def current_user
    current_user = User.where(id: session[:user_id]).select(:id, :username, :email)
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

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url(@today)) unless current_user?(@user)
  end

  def validate_email_update
    @new_email = params[:user][:email]
    if @new_email == current_user.email
      @new_email = nil
    elsif User.email_used?(@new_email)
      @new_email = nil
      flash[:danger] = 'このメールアドレスはすでに使われています'
      redirect_to edit_user_path(current_user)
    end
  end
end
