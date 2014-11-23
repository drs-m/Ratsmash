class ContactsController < ApplicationController

	def index
		if logged_in?
			@name = @current_user.name
			@mail = @current_user.mail_address
		end
	end

	def send_contact_form
		if !params[:name].blank? && !params[:mail].blank? && !params[:subject].blank? && !params[:message].blank?
			ContactMailer.send_contact_mail(params[:name], params[:mail], params[:subject], params[:message]).deliver
			flash[:notice] = "Deine Nachricht wurde erfolgreich an das Ratsmash-Team geschickt!"
		else
			flash[:error] = "Bitte alle Felder ausfuellen zum Versenden der Mail!"
		end

		redirect_to :contacts
	end

end
