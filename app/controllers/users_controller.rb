class UsersController < ApplicationController
  before_action :logged_in_user, except: [ :new, :create ]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:notice] = 'ユーザー登録が完了しました。'
      redirect_to index_path(@today)
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :email)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path(@today)).current_user(@user)
  end
end
