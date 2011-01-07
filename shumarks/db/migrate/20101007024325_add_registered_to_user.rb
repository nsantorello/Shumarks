class AddRegisteredToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :is_registered, :boolean
    
    for user in User.all
      user.is_registered = true
      user.save()
    end
  end

  def self.down
    remove_column :users, :is_registered
  end
end
