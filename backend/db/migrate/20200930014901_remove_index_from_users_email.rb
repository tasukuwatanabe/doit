class RemoveIndexFromUsersEmail < ActiveRecord::Migration[6.0]
  def up
    remove_index :users, :email
    change_column :users, :username, :string, null: false
    change_column :users, :email, :string, null: false
    change_column :users, :password_digest, :string, null: false
    remove_column :shortcuts, :body
  end

  def down
    add_index :users, :email, unique: true
    change_column :users, :username, :string
    change_column :users, :email, :string
    change_column :users, :password_digest, :string
    add_column :shortcuts, :body, :text
  end
end
