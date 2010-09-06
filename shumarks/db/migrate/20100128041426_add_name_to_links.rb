class AddNameToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :name, :string
  end

  def self.down
    remove_column :links, :name
  end
end
