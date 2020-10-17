class RenameTwitterProfileImage < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :sns_profile_image, :sns_profile_image
  end
end
