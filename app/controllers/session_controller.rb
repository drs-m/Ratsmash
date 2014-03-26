# encoding: utf-8
class SessionController < ApplicationController
	
	def login
		# redirect if logged in
		redirect_to controller: "vote", action: "menu" if session[:acc_id]

		# form sent?
		if params[:email]
			account = Student.find_by mail_address: params[:email]
			@errors = []
			if !account.blank?
				if account.authenticate params[:password]
					session[:acc_id] = account.id
					redirect_to controller: "vote", action: "menu"
				else
					@errors << "Das eingegebene Passwort ist falsch"
				end
			else
				@errors << "Der Account konnte nicht gefunden werden"
			end
		end
	end

	def logout
		session[:acc_id] = nil
		redirect_to action: "login"
	end

	def instantlogin
		session[:acc_id] = Student.offset(rand(Student.count)).first
		redirect_to :home
	end

end
