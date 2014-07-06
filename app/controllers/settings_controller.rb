class SettingsController < ApplicationController

	before_action -> { check_session redirect: true, admin_permissions: true }
    
end
