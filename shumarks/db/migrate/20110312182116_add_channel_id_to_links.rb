class AddChannelIdToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :channel_id, :integer  
  end

  def self.down
    remove_column :links, :channel_id
  end
end
