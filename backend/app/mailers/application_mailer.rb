class ApplicationMailer < ActionMailer::Base
  default from: 'DoIT <noreply@doit-app.com>'
  layout 'mailer'

  def client_host
    if Rails.env.production?
      "https://doit-app.com"
    elsif Rails.env.test?
      "http://www.example.com"
    else
      "http://localhost:8080"
    end
  end
end