class AddStartAndEndDateToTodos < ActiveRecord::Migration[6.0]
  def change
    add_column :todos, :start_date, :date, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :todos, :end_date, :date
    add_column :todos, :continue_without_end, :boolean, default: false
    add_column :todos, :apply_days, :integer, array: true
    add_column :todos, :history_display, :boolean, default: false
    add_column :todos, :body, :text
    add_column :todos, :label_id, :integer
  end
end
