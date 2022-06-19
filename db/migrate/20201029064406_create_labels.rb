class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :title, default: false
      t.string :color, default: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
