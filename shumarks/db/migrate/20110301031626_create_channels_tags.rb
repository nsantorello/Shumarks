class CreateChannelsTags < ActiveRecord::Migration
  def self.up
    create_table :channels_tags, :id => false do |t|
      t.integer :channel_id
      t.integer :tag_id
      t.timestamps
    end
  end

  def self.down
    drop_table :channels_tags
  end
end
