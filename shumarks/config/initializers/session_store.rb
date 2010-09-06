# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_shumarks_session',
  :secret      => '08a8fc842d6b403896938a739eaa1c4f5304669141f2a5d8b330e5eaf09c406989b8e588a39370b1a49d24ee64f61fa99970967267c947bcbf14aed2352039ce'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
