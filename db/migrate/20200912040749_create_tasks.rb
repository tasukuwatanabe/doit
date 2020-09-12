class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :body
      t.integer :status, null: false, default: 0
      t.datetime :limit_at
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
