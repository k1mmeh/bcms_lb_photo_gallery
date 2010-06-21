# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bcms_lb_photo_gallery_session',
  :secret      => 'b9201e11ec001bea4a908ea94809cdab6277eb9af60f197051808217a7323115450f7ad8642f347366ffa99fc1ecca69146e724b55e34ec8b05450859bf49abf'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
