Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET'], scope: 'email', callback_url: 'http://localhost:3000/auth/twitter/callback'
end
