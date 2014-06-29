# Load the Rails application.
require File.expand_path('../application', __FILE__)

RAILS_ROOT = Rails.root.to_s

RELEASE_STATE_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")

# Initialize the Rails application.
Ratsmash::Application.initialize!