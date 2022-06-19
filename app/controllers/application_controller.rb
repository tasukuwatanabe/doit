class ApplicationController < ActionController::API
  include ActionController::Cookies
  include SessionsHelper
  include SessionModule
  include ErrorModule
  include Constants
end
