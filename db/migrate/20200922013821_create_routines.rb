class CreateRoutines < ActiveRecord::Migration[6.0]
  def change
    create_table :routines do |t|
      t.string :title, null: false
      t.text :body
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :skip_day
      t.boolean :progress_display, null: false, default: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
