# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110128215754) do

  create_table "comments", :force => true do |t|
    t.string   "text"
    t.integer  "user_id"
    t.integer  "link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_auths", :force => true do |t|
    t.string   "screen_name"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", :force => true do |t|
    t.integer  "follower_id", :null => false
    t.integer  "followee_id", :null => false
    t.datetime "created_at"
  end

  create_table "links", :force => true do |t|
    t.integer  "user_id"
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "blurb"
  end

  create_table "read_receipts", :force => true do |t|
    t.integer  "link_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "session_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "ruby_session_id", :null => false
    t.integer  "user_id"
    t.string   "referrer"
    t.string   "user_agent"
    t.string   "client_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "destroyed_at"
  end

  add_index "sessions", ["referrer"], :name => "index_sessions_on_referrer"
  add_index "sessions", ["ruby_session_id"], :name => "index_sessions_on_ruby_session_id"
  add_index "sessions", ["user_id"], :name => "index_sessions_on_user_id"

  create_table "tutorial_examples", :force => true do |t|
    t.string "username"
  end

  create_table "twitter_auths", :force => true do |t|
    t.string   "screen_name"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "bio"
    t.boolean  "is_registered"
  end

  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
