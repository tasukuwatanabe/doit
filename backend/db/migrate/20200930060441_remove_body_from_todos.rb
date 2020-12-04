class RemoveBodyFromTodos < ActiveRecord::Migration[6.0]
  def up
    remove_column :todos, :body
  end

  def down
    add_column :todos, :body, :text
  end
end
