class AddIndexToUsers < ActiveRecord::Migration
  def self.up
    add_index :users, :login, :unique => true
    add_index :users, :first_name
    add_index :users, :last_name
  end

  def self.down
    remove_index :users, :login
    remove_index :users, :first_name
    remove_index :users, :last_name
  end
end
