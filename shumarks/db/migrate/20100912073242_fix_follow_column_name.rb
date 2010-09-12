class FixFollowColumnName < ActiveRecord::Migration
  def self.up
    rename_column :follows, :user_id, :follower_id
  end

  def self.down
    
  end
end
