class AddColumnReadReceipts < ActiveRecord::Migration
  def self.up
    add_column :read_receipts, :session_id, :integer
  end

  def self.down
    remove_column :read_receipts, :session_id
  end
end
