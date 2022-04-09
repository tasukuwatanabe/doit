class OmniauthUser
  attr_reader :user

  def initialize(auth)
    @uid = auth[:uid]
    @name = auth[:info][:name]
    @email = auth[:info][:email]
    @user = User.find_by(email: @email) || find_by_uid || User.new 
  end

  def find_or_create
    if @user.persisted?
      activate_and_update_uid
    else
      password = SecureRandom.hex(10)
      @user.attributes = {
        username: @name,
        email: @email,
        password: password,
        password_confirmation: password,
        auto_generated_password: true,
        activated: true,
        activated_at: Time.zone.now,
      }.merge(uid_hash)

      @user.save!
    end

    @user
  end

  private

  def activate_and_update_uid
    update_uid

    unless user.activated?
      @user.update(
        activated: true,
        activated_at: Time.zone.now,
        activation_digest: nil
      )
    end
  end

  def find_by_uid
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def update_uid
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def uid_hash
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end
end
