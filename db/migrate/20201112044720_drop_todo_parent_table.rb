class DropTodoParentTable < ActiveRecord::Migration[6.0]
  def change
    drop_table 'todo_parents', force: :cascade do |t|
      t.bigint 'user_id'
      t.datetime 'created_at', precision: 6, null: false
      t.datetime 'updated_at', precision: 6, null: false
      t.index ['user_id'], name: 'index_todo_parents_on_user_id'
    end
  end
end
