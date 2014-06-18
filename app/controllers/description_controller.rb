class DescriptionController < ApplicationController
	before_action -> { check_session redirect: true }

	
end
