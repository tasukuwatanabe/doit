class AlterUserImageToInteger < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :user_image, :string
  end
end
