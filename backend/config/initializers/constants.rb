module Constants
  SERVER_HOST = if Rails.env.production?
                  "https://production.com/"
                elsif Rails.env.test?
                  "http://example.com/"
                else
                  "http://localhost:3000/"
                end
end