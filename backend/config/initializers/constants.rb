module Constants
  UPLOAD_HOST = if Rails.env.production?
                  "https://doit-image.s3-ap-northeast-1.amazonaws.com"
                else
                  "http://localhost:3000"
                end

  CLIENT_HOST = if Rails.env.production?
                  "https://twatanabe-doit-backend.herokuapp.com"
                elsif Rails.env.test?
                  "http://www.example.com"
                else
                  "http://localhost:8080"
                end
end