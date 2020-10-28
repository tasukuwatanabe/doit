class HomeController < ApplicationController
  def root
    redirect_to todo_index_path(@today)
  end
end
