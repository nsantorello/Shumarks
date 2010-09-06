class AddViewedToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :is_viewed, :boolean
    
    # Populate all existing fields
    Link.find(:all).each do |l|
      l.update_attribute(:is_viewed, false) if l.is_viewed.blank?
    end
  end

  def self.down
    remove_column :links, :is_viewed
  end
end
