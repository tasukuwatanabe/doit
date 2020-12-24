class ChangePasswordForm
  include ActiveModel::Model

  attr_accessor :user, :password, :password_confirmation

  validates :password,
            presence: true,
            length: { minimum: 6, maximum: 20 },
            confirmation: true
  validates :password_confirmation,
            presence: true

  delegate :persisted?, to: :user

  def initialize(user, params)
    @user = user
    @params = params
  end

  def save
    return false if invalid?
    @user.auto_generated_password = nil
    @user.password = @params[:password]
    @user.save!
    true
  end
end