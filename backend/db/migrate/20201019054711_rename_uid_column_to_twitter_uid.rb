class RenameUidColumnToTwitterUid < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :uid, :twitter_uid
    add_column :users, :facebook_uid, :string
  end
end
