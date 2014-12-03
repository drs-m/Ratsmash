# Be sure to restart your server when you modify this file.

Ratsmash::Application.config.session_store :cookie_store, key: '_Ratsmash_session', domain: (Rails.env.production? ? "rmash.de" : :all)
