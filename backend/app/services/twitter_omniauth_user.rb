class TwitterOmniauthUser < OmniauthUser
  private

  def find_by_uid
    User.find_by(twitter_uid: @uid)
  end

  def update_uid
    @user.update(twitter_uid: @uid)
  end

  def uid_hash
    { tiwtter_uid: @uid }
  end
end
