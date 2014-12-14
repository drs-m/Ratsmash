class SettingsController < ApplicationController

	before_action -> { check_session redirect: true, restricted_methods: [:all] }

end
