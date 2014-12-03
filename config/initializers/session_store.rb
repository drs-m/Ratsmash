# Be sure to restart your server when you modify this file.

if Rails.env.development?
    Ratsmash::Application.config.session_store :cookie_store, key: '_Ratsmash_session', domain: :all
else
    Ratsmash::Application.config.session_store :cookie_store, key: '_Ratsmash_session', domain: "rmash.de"
end
