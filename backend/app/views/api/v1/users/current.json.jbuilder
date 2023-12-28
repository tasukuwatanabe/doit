if @current_user.present?
  json.id @current_user.id
  json.username @current_user.username
  json.email @current_user.email
  json.unconfirmed_email @current_user.unconfirmed_email
end
