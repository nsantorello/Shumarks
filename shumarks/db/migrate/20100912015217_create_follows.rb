class CreateFollows < ActiveRecord::Migration
  def self.up
    create_table :follows do |t|
      t.integer :user_id
      t.integer :follow_id

      t.timestamps
    end
  end

  def self.down
    drop_table :follows
  end
end
