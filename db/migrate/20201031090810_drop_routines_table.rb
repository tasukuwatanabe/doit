class DropRoutinesTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :todos, :routine_id, :integer

    drop_table :routines do |t|
      t.bigint 'user_id'
      t.datetime 'created_at', precision: 6, null: false
      t.datetime 'updated_at', precision: 6, null: false
      t.string 'title', null: false
      t.date 'start_date', null: false
      t.date 'end_date'
      t.index ['user_id'], name: 'index_routines_on_user_id'
    end
  end
end
