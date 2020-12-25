class ApplicationController < ActionController::API
  include ActionController::Cookies
  include SessionsHelper
  include ErrorFormat
  include Constants
end
