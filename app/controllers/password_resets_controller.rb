class PasswordResetsController < ApplicationController
  skip_before_action :logged_in_user
  before_action :get_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new
    @form = PasswordResetForm.new
  end

  def create
    @form = PasswordResetForm.new(password_reset_params)
    @user = User.find_by(email: @form.email)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:success] = 'パスワード再設定用のメールが送信されました'
      redirect_to login_path
    else
      flash.now[:danger] = 'メールアドレスが見つかりません'
      render action: 'new'
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render action: 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = 'パスワードがリセットされました。'
      redirect_to @user
    else
      render action: 'edit'
    end
  end

  private

  def password_reset_params
    params.require(:password_reset_form).permit(:email)
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    redirect_to root_url unless @user&.authenticated?(:reset, params[:id])
  end

  def check_expiration
    if @user.expired?(:reset)
      @user.reset_digest = nil
      @user.save
      flash[:danger] = 'パスワード再設定の期限が切れています'
      redirect_to new_password_reset_url
    end
  end
end
