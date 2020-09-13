class TopController < ApplicationController
  def dashboard
    redirect_to index_path(@today)
  end
end
