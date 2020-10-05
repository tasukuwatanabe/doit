class Api::ShortcutsController < ApplicationController
  protect_from_forgery except: [:create, :update, :destroy]

  before_action :logged_in_user
  before_action :set_shortcut, only: [ :edit, :update, :destroy, :create_todo ]

  def index
    shortcuts = current_user.shortcuts.select(:id, :title)
    render json: shortcuts
  end

  def create
    shortcut = current_user.shortcuts.build(shortcut_params)
    if shortcut.save
      head :no_content
    else
      render json: { error: shortcut.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  def update
    if @shortcut.update(shortcut_params)
      head :no_content
    else
      render json: { error: @shortcut.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  def destroy
    if @shortcut.destroy
      head :no_content
    else
      render json: { error: shortcut.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  private

  def set_shortcut
    @shortcut = Shortcut.find(params[:id])
  end

  def shortcut_params
    params.fetch(:shortcut, {}).permit(:id, :title)
  end
end
