class AddColorColumnToLabels < ActiveRecord::Migration[6.0]
  def change
    remove_column :labels, :title, :string, default: 'f'
    remove_column :labels, :color, :string, default: 'f'
    add_column :labels, :title, :string
    add_column :labels, :color, :string
  end
end
