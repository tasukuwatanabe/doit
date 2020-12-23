class ApplicationMailer < ActionMailer::Base
  before_action :set_client_host

  default from: 'DoIT <noreply@doit-app.com>'
  layout 'mailer'

  private

  def set_client_host
    @client_host = if Rails.env.production?
                      "https://doit-app.com"
                    elsif Rails.env.test?
                      "http://www.example.com"
                    else
                      "http://localhost:8080"
                    end
  end
end