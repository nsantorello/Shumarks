class CreateReadReceipt < ActiveRecord::Migration
  def self.up
    create_table :read_receipts do |t|
      t.integer :link_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :read_receipts
  end
end
