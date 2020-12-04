class AddReferencesToTodos < ActiveRecord::Migration[6.0]
  def up
    remove_column :todos, :user_id
    remove_column :todos, :routine_id
    add_reference :todos, :user, foreign_key: true
  end

  def drop
    add_column :user_id, null: false
    add_column :routine_id
    remove_reference :todos, :user
  end
end
