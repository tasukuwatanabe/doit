class AddLabelIdToShortcut < ActiveRecord::Migration[6.0]
  def change
    add_column :shortcuts, :label_id, :integer
  end
end
