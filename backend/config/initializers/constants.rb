module Constants
  CLIENT_HOST ||= if Rails.env.production?
                  "https://app.doit-plan.com"
                elsif Rails.env.test?
                  "http://www.example.com"
                else
                  "http://localhost:8080"
                end
end
