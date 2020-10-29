class LabelsController < ApplicationController
  def index
    @labels = current_user.labels.all
  end

  def create; end

  def edit; end

  def update; end

  def destroy; end
end
