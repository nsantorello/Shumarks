class InitFollowCreatedDate < ActiveRecord::Migration
  def self.up
    Follow.all.each do |f|
      f.created_at = Time.now
      f.save
    end
  end

  def self.down
  end
end
