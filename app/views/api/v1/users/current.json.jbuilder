if @current_user.present?
  json.id @current_user.id
  json.username @current_user.username
  json.email @current_user.email
  json.user_image @current_user.user_image
  json.facebook_uid @current_user.facebook_uid
  json.twitter_uid @current_user.twitter_uid
  json.google_uid @current_user.google_uid
  json.auto_generated_password @current_user.auto_generated_password
  json.unconfirmed_email @current_user.unconfirmed_email
end