class CreateLinksTags < ActiveRecord::Migration
  def self.up
    create_table :links_tags, :id => false do |t|
      t.column    :link_id,      :integer,   :null => false
      t.column    :tag_id,       :integer,   :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :links_tags
  end
end
