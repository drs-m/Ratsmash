# encoding: utf-8
class SessionController < ApplicationController
	
	def login
		# redirect if logged in
		redirect_to :home if logged_in?

		# form sent?
		if params[:email]
			# unnötig, da die email-adressen von uns eingetragen werden
			# regex = /([a-z.]+)@rats-os.de/
			# flash[:notice] = "Die angegebene E-Mail Adresse ist nicht vom IServ." and return if !regex.match params[:email]
			student = Student.find_by mail_address: params[:email]
			if student
				if student.authenticate params[:password]
					if student.closed
						flash[:notice] = "Dein Account wurde gesperrt! Bitte wende dich an die Abizeitung oder das Ratsmash-Team."
					else
						if params[:persist]	
							cookies.permanent.signed[:at] = student.auth_token
						else	
							cookies.signed[:at] = student.auth_token
						end
						redirect_to :home
					end
				else
					flash[:notice] = "Das eingegebene Passwort ist falsch"
				end
			else
				flash[:notice] = "Der Account konnte nicht gefunden werden"
			end
		end
	end

	def logout
		cookies.delete :at
		redirect_to :login
	end

	def reset_password
		if params[:email]
			student = Student.find_by mail_address: params[:email]
			if student
				if student.closed
					@closed_error = true
				else
					student.send_password_help_mail if student
					@success = true
				end
			end
		end
	end

	def instant_login
		redirect_to :login and return if not Rails.env.development?
		cookies.permanent.signed[:at] = Student.where(admin_permissions: true).first.auth_token
		redirect_to :home
	end

end
