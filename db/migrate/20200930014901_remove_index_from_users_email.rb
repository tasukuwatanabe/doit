class RemoveIndexFromUsersEmail < ActiveRecord::Migration[6.0]
  def up
    remove_index :users, :email
    change_column :users, :username, :string, null: false
    change_column :users, :email, :string, null: false
    change_column :users, :password_digest, :string, null: false
    change_column :routines, :end_date, :date, null: true
    remove_column :routines, :body
    remove_column :routines, :skip_days
    remove_column :routines, :progress_display
    remove_column :shortcuts, :body
  end

  def down
    add_index :users, :email, unique: true
    change_column :users, :username, :string
    change_column :users, :email, :string
    change_column :users, :password_digest, :string
    change_column :routines, :end_date, :date, null: false
    add_column :routines, :body, :text
    add_column :routines, :skip_days, :text
    add_column :routines, :progress_display, :boolean
    add_column :shortcuts, :body, :text
  end
end
