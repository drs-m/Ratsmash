class ContactsController < ApplicationController

	def index
		if cookies[:at]
			@name = Student.find_by(auth_token: cookies[:at]).name
			@mail = Student.find_by(auth_token: cookies[:at]).mail_address
		end
	end

	def send_contact_form
		if !params[:name].blank? && !params[:mail].blank? && !params[:subject].blank? && !params[:message].blank?
			ContactMailer.send_contact_mail(params[:name],params[:mail],"rmashteam@gmail.com", params[:subject], params[:message]).deliver
		end

		redirect_to :contacts
	end

end