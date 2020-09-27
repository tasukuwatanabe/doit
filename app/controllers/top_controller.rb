class TopController < ApplicationController
  before_action :logged_in_user

  def dashboard
    redirect_to index_path(@today)
  end
end
