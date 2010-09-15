class RemoveIsViewdFromLinks < ActiveRecord::Migration
  def self.up
    remove_column :links, :is_viewed
  end

  def self.down
    add_column :links, :is_viewed, :boolean
  end
end
