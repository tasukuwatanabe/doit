class RenameConfirmationColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :confirmation_token, :confirmation_digest
  end
end
