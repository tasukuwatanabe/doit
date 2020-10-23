class UsersController < ApplicationController
  skip_before_action :logged_in_user, only: %i[index new create]
  before_action :forbid_guest_user, only: :destroy
  before_action :forbid_login_user, only: %i[new create]
  before_action :set_user, only: %i[edit update destroy]
  before_action :correct_user, only: %i[edit update]
  before_action :validate_email_update, only: :update

  def index
    redirect_to signup_path
  end

  def show
    redirect_to edit_user_path(current_user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = 'アカウント有効化のためのメールを送信しました'
      redirect_to signup_path
    else
      render action: 'new'
    end
  end

  def edit; end

  def update
    @user.sns_profile_image = nil if params[:user][:remove_user_image] == '1'
    current_user.set_unconfirmed_email(@new_email) if @new_email
    if @user.update(user_params.except(:email))
      flash[:success] = 'ユーザ情報を更新しました'
      redirect_to edit_user_path(current_user)
    else
      render action: 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = 'アカウントを削除しました。'
    redirect_to signup_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :email, :password_confirmation, :user_image, :remove_user_image)
  end

  def set_user
    @user = User.find(params[:id])
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
