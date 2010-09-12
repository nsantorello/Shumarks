# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_twitsrv_session',
  :secret      => '4fa250e9b4352434aa7aec7b87e951e4dfe4f1e3542db63bf2af3d3ecbd83df3365aa545e49fe6d8b4e8dd16b8b71601f8f8a0e6d37103b7747d42a9c2ca3a2e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
