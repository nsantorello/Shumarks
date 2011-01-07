class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.string :ruby_session_id, :null => false
      t.integer :user_id
      t.string :referrer
      t.string :user_agent
      t.string :client_ip
      
      t.timestamps
      t.timestamp :destroyed_at
    end

    add_index :sessions, :ruby_session_id
    add_index :sessions, :user_id
    add_index :sessions, :referrer
  end

  def self.down
    drop_table :sessions
    drop_table :session_actions
    drop_table :session_action_types
  end
end
