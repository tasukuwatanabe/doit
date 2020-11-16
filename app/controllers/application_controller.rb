class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  class Forbidden < ActionController::ActionControllerError; end
  class IpAddressRejected < ActionController::ActionControllerError; end

  include ErrorHandlers if Rails.env.production?
  include SessionsHelper
end
