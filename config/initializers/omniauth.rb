Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET'], scope: 'email', callback_url: 'http://localhost:3000/auth/twitter/callback'
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], skip_jwt: true
  OmniAuth.config.on_failure = proc do |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  end
end
