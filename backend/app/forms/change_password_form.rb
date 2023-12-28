class ChangePasswordForm
  include ActiveModel::Model

  attr_accessor :user, :password, :password_confirmation

  validate :promote_user_valid

  def initialize(user, params)
    @user = user
    @password = params[:password]
    @password_confirmation = params[:password_confirmation]
  end

  def save
    return false unless valid?

    user.save
  end

  private

  def promote_user_valid
    user.attributes = {
      password: password,
      password_confirmation: password_confirmation
    }
    user.valid?
    user.errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end
