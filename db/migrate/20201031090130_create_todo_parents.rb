class CreateTodoParents < ActiveRecord::Migration[6.0]
  def change
    create_table :todo_parents do |t|
      t.references :user, foreign_key: true
      t.timestamps
    end

    add_column :todos, :todo_parent_id, :integer
  end
end
