class RemoveGoogleUidFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :google_uid
    remove_column :users, :twitter_uid
    remove_column :users, :facebook_uid
    remove_column :users, :sns_profile_image
    remove_column :users, :auto_generated_password
  end
end
