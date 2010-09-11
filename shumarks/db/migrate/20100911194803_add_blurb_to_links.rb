class AddBlurbToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :blurb, :string
  end

  def self.down
    remove_column :links, :blurb
  end
end
