class AddTwitterProfileImageToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sns_profile_image, :string
  end
end
