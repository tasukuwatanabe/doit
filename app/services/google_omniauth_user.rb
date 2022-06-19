class GoogleOmniauthUser < OmniauthUser
  private

  def find_by_uid
    User.find_by(google_uid: @uid)
  end

  def update_uid
    @user.update(google_uid: @uid)
  end

  def uid_hash
    { google_uid: @uid }
  end
end
