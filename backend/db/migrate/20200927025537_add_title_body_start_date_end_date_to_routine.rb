class AddTitleBodyStartDateEndDateToRoutine < ActiveRecord::Migration[6.0]
  def change
    remove_column :todos, :start_date
    remove_column :todos, :end_date
  end
end
