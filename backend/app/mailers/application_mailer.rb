class ApplicationMailer < ActionMailer::Base
  add_template_helper(SessionsHelper)

  default from: 'DoIT <noreply@doit-app.com>'
  layout 'mailer'
end