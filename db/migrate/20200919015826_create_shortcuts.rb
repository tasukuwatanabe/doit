class CreateShortcuts < ActiveRecord::Migration[6.0]
  def change
    create_table :shortcuts do |t|
      t.string :title, null: false
      t.text :body
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
