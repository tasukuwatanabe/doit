class CreateTodos < ActiveRecord::Migration[6.0]
  def change
    create_table :todos do |t|
      t.string :title, null: false
      t.text :body
      t.date :todo_date, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.boolean :status, null: false, default: false
      t.integer :user_id, null: false
      t.integer :routine_id

      t.timestamps
    end
  end
end
