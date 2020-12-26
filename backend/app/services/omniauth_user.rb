class OmniauthUser
  attr_reader :user

  def initialize(auth)
    @provider = auth[:provider]
    @uid = auth[:uid]
    @name = auth[:info][:name]
    @email = auth[:info][:email]
    @user = find_user_from_auth || User.new 
  end

  def find_or_create
    if @user.persisted?
      activate_and_update_uid
    else
      password = "passwordhoge"
      @user.attributes = {
        username: @name,
        email: @email,
        password: password,
        password_confirmation: password,
        auto_generated_password: true,
        activated: true,
        activated_at: Time.zone.now,
        twitter_uid: nil,
        facebook_uid: nil,
        google_uid: nil
      }

      if @provider == 'twitter'
        @user.twitter_uid = @uid
      elsif @provider == 'facebook'
        @user.facebook_uid = @uid
      elsif @provider == 'google_oauth2'
        @user.google_uid = @uid
      end

      @user.save!
    end

    @user
  end

  private

  def activate_and_update_uid
    if @provider == 'twitter' && @user.twitter_uid.nil?
      @user.update(twitter_uid: @uid)
    elsif @provider == 'facebook' && @user.facebook_uid.nil?
      @user.update(facebook_uid: @uid)
    elsif @provider == 'google_oauth2' && @user.google_uid.nil?
      @user.update(google_uid: @uid)
    end

    unless user.activated?
      @user.update(
        activated: true,
        activated_at: Time.zone.now,
        activation_digest: nil
      )
    end
  end

  def find_user_from_auth
    user = User.find_by(email: @email)
    if user.present?
      user = User.find_by(twitter_uid: @uid) ||
             User.find_by(facebook_uid: @uid) ||
             User.find_by(google_uid: @uid)
    end
    user
  end
end
