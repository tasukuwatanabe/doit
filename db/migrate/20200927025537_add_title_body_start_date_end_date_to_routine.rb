class AddTitleBodyStartDateEndDateToRoutine < ActiveRecord::Migration[6.0]
  def change
    add_column :routines, :title, :string, null: false
    add_column :routines, :body, :text
    add_column :routines, :start_date, :date, null: false
    add_column :routines, :end_date, :date, null: false
    add_column :routines, :skip_days, :text, array: true, default: []
    add_column :routines, :progress_display, :boolean, null: false, default: true
    remove_column :todos, :start_date
    remove_column :todos, :end_date
  end
end
