class CreateTodoLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :todo_labels do |t|
      t.references :todo, null: false, foreign_key: true
      t.references :label, null: false, foreign_key: true

      t.timestamps
    end
  end
end
