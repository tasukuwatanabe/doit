class RemoveDateColumnsFromTodos < ActiveRecord::Migration[6.0]
  def change
    remove_column :todos, :start_date, :date
    remove_column :todos, :end_date, :date
    remove_column :todos, :continue_without_end, :boolean
    remove_column :todos, :apply_days, :integer
    remove_column :todos, :history_display, :boolean
  end
end
