class OmniauthUserCreateService
  OMNIAUTH_USER_CLASSES = {
    twitter: TwitterOmniauthUser,
    facebook: FacebookOmniauthUser,
    google_oauth2: GoogleOmniauthUser,
  }.freeze

  def initialize(auth)
    @object = OMNIAUTH_USER_CLASSES[auth[:provider].to_sym].new(auth)
  end

  def result
    @object.find_or_create
  end
end
