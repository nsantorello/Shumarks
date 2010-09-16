class AddColumnToFollows < ActiveRecord::Migration
  def self.up
    add_column :follows, :created_at, :timestamp
    Follow.all.each do |f|
      f.created_at = Time.now
    end
  end

  def self.down
    remove_column :follows, :created_at
  end
end
