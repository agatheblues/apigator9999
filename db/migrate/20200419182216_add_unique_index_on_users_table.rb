class AddUniqueIndexOnUsersTable < ActiveRecord::Migration[5.2]
  def change
    remove_index :users, :email
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
