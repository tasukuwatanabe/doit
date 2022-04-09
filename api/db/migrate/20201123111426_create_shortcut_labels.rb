class CreateShortcutLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :shortcut_labels do |t|
      t.references :shortcut, null: false, foreign_key: true
      t.references :label, null: false, foreign_key: true

      t.timestamps
    end
  end
end
