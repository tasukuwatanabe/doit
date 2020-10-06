class LoginForm
  include ActiveModel::Model

  attr_accessor :email, :password, :remember_me
end
