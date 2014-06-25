class ContactController < ApplicationController

	def index

	end

	def send_contact_form
		if !params[:name].blank? && !params[:mail].blank? && !params[:subject].blank? && !params[:message].blank? 

		end
	end

end
