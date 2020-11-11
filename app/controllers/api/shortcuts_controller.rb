class Api::ShortcutsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    shortcuts = current_user.shortcuts.order(created_at: :desc).select(:id, :title, :label_id)
    labels = current_user.labels.order(created_at: :desc).select(:id, :title, :color)
    shortcuts.each do |shortcut|
      labels.select { |label| label.id == shortcut.label_id }
    end
    api_array = {
      shortcuts: shortcuts,
      labels: labels
    }
    render json: api_array
  end

  def create
    shortcut = current_user.shortcuts.build(shortcut_params)
    if shortcut.save
      head :no_content
    else
      render json: shortcut.errors, status: :unprocessable_entity
    end
  end

  def update
    shortcut = Shortcut.find(params[:id])
    if shortcut.update(shortcut_params)
      head :no_content
    else
      render json: shortcut.errors, status: :unprocessable_entity
    end
  end

  def destroy
    shortcut = Shortcut.find(params[:id])
    if shortcut.destroy
      head :no_content
    else
      render json: shortcut.errors, status: :unprocessable_entity
    end
  end

  private

  def shortcut_params
    params.fetch(:shortcut, {}).permit(:id, :title, :label_id)
  end
end
