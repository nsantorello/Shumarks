class InitFollowCreatedDate < ActiveRecord::Migration
  def self.up
    add_column :follows, :id, :primary_key
    i = 1
    Follow.all.each do |f|
      f.id = i
      f.created_at =Time.now
      f.save
      i = i + 1
    end
  end

  def self.down
    remove_column :follows, :id
  end
end
