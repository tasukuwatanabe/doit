module Constants
  SERVER_HOST = if Rails.env.production?
                  "https://doit-image.s3-ap-northeast-1.amazonaws.com/"
                else
                  "http://localhost:3000/"
                end
end