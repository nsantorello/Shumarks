class RemakeFollowsTable < ActiveRecord::Migration
  def self.up
    drop_table :follows
    create_table "follows", :force => true, :id => false do |t|
      t.integer "follower_id", :null => false
      t.integer "follow_id", :null => false
    end
  end

  def self.down
    drop_table :follows
  end
end
