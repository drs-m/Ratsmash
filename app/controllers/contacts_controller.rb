class ContactsController < ApplicationController

	def index
		if logged_in?
			@name = @current_user.name
			@mail = @current_user.mail_address
		end
	end

	def send_contact_form
		if !params[:name].blank? && !params[:mail].blank? && !params[:subject].blank? && !params[:message].blank?
			ContactMailer.send_contact_mail(params[:name],params[:mail],"rmashteam@gmail.com", params[:subject], params[:message]).deliver
		end

		redirect_to :contacts, notice: 'Deine Nachricht wurde erfolgreich an das Ratsmah-Team geschickt!'
	end

end