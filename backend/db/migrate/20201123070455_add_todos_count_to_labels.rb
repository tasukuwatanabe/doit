class AddTodosCountToLabels < ActiveRecord::Migration[6.0]
  def change
    add_column :labels, :todos_count, :integer
  end
end
