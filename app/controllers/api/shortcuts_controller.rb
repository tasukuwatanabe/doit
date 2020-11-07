class Api::ShortcutsController < ApplicationController
  def index
    shortcuts = current_user.shortcuts.order(created_at: :desc).all
    render json: shortcuts
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
