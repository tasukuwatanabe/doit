class ShortcutsController < ApplicationController
  before_action :logged_in_user
  before_action :set_shortcut, only: [ :edit, :update, :destroy, :create_todo ]

  def index
    @shortcuts = current_user.shortcuts
    if @shortcuts.count >= Shortcut::MAX_SHORTCUT_COUNT
      @disabled = 'disabled'
    end
  end

  def new
    if current_user.shortcuts.count >= Shortcut::MAX_SHORTCUT_COUNT
      flash[:danger] = "ショートカットが登録できるのは#{Shortcut::MAX_SHORTCUT_COUNT}個までです。"
      redirect_to shortcuts_path
    end

    @shortcut = Shortcut.new
  end

  def create
    @shortcut = current_user.shortcuts.build(shortcut_params)
    if @shortcut.save
      flash[:success] = 'ショートカットを作成しました'
      redirect_to shortcuts_path
    else
      render action: 'new'
    end
  end

  def show
    redirect_to edit_shortcut_path
  end

  def edit; end

  def update
    @shortcut.assign_attributes(shortcut_params)
    if @shortcut.save
      flash[:success] = 'ショートカットを更新しました'
      redirect_to shortcuts_path
    else
      render action: 'edit'
    end
  end

  def destroy
    @shortcut.destroy
    flash[:success] = 'ショートカットを削除しました。'
    redirect_to shortcuts_path
  end

  def create_todo
    @todo = current_user.todos.build(
      title: @shortcut.title,
      todo_date: params[:date]
    )

    if @todo.save
      flash[:success] = 'ToDoが追加されました。'
      redirect_to dashboard_path(@todo.todo_date)
    else
      flash[:danger] = @todo.errors.messages.values[0][0]
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def set_shortcut
    @shortcut = Shortcut.find(params[:id])
  end

  def shortcut_params
    params.require(:shortcut).permit(:title, :body, :todo_date)
  end
end
