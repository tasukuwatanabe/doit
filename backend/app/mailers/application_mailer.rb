class ApplicationMailer < ActionMailer::Base
  default from: 'DoIT <noreply@twatanabe-doit-backend.herokuapp.com>'
  layout 'mailer'
end