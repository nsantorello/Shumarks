class RenameFollowsColumn < ActiveRecord::Migration
  def self.up
    rename_column :follows, :follow_id, :followee_id
  end

  def self.down
    rename_column :follows, :followee_id, :follow_id
  end
end
