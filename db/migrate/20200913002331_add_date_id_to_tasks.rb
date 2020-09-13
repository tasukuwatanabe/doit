class AddDateIdToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :date_id, :string
  end
end
