# encoding: utf-8
class SessionController < ApplicationController
	
	def login
		# redirect if logged in
		redirect_to :home if logged_in?

		# form sent?
		if params[:email]
			student = Student.find_by mail_address: params[:email]
			if student
				if student.authenticate params[:password]
					if student.closed
						flash[:notice] = "Dein Account wurde gesperrt! Bitte wende dich an die Abizeitung oder das Ratsmash-Team."
					else
						if params[:persist]	
							cookies.permanent[:at] = student.auth_token
						else	
							cookies[:at] = student.auth_token
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
			student.send_password_reset if student
			@success = true
		end
	end

	def instantlogin
		cookies.permanent[:at] = Student.offset(rand(Student.count)).first.auth_token
		redirect_to :home
	end

end
