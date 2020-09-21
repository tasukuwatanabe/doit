class AddDateIdToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :date_id, :string
    add_index :tasks, [ :date_id, :title, :user_id ], unique: true
  end
end
