class CreateTwitterAuths < ActiveRecord::Migration
  def self.up
    create_table :twitter_auths do |t|
      t.string :screen_name
      t.string :token
      t.string :secret

      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_auths
  end
end
