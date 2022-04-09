class Authenticator
  def initialize(user)
    @user = user
  end

  def authenticate(raw_password)
    @user && BCrypt::Password.new(@user.password_digest) == raw_password
  end
end
