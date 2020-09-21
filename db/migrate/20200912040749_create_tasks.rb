class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :body
      t.boolean :status, null: false, default: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
