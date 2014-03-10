# Be sure to restart your server when you modify this file.
Desy::Application.config.session_store :cookie_store, key: SETTINGS['cookie_key']

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")

# TODO In Rails la sessione è nei cookie di default, controllare se ciò
# è utile in qualche modo
Desy::Application.config.session_store :active_record_store, { expire_after: SETTINGS['session_timeout'].hours }
