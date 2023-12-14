class DropLabelIdFromShortcuts < ActiveRecord::Migration[6.0]
  def change
    remove_column :shortcuts, :label_id, :integer
  end
end
