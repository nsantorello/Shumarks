class AddColumnToFollows < ActiveRecord::Migration
  def self.up
    add_column :follows, :created_at, :timestamp
  end

  def self.down
    remove_column :follows, :created_at
  end
end
