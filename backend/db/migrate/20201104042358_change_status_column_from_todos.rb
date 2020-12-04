class ChangeStatusColumnFromTodos < ActiveRecord::Migration[6.0]
  def up
    change_column :todos, :status, :boolean, default: false, null: true
  end

  def down
    change_column :todos, :status, :boolean, default: false, null: false
  end
end
