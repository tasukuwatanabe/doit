class FacebookOmniauthUser < OmniauthUser
  private

  def find_by_uid
    User.find_by(facebook_uid: @uid)
  end

  def update_uid
    @user.update(facebook_uid: @uid)
  end

  def uid_hash
    { facebook_uid: @uid }
  end
end
