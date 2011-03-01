class AddTutorialExample < ActiveRecord::Migration
  def self.up
    create_table :tutorial_examples do |t|
      t.string :username
    end
  end

  def self.down
    drop_table :tutorial_examples
  end
end
