# encoding: utf-8
class SessionController < ApplicationController
	
	def login
		# redirect if logged in
		if logged_in?
			respond_to do |format|
				format.html { redirect_to(:home) and return }
				format.json { render(:json => { status: :success }) and return }
			end
		end

		# form sent?
		if params[:email] # and request.post?
			puts "login attempt" # dev
			student = Student.find_by mail_address: params[:email]
			if student
				if !params[:password].present?
					error = "Bitte gib ein Passwort ein!"
				else 
					if student.authenticate params[:password]
						if student.closed
							error = "Dein Account wurde gesperrt! Bitte wende dich an die Abizeitung oder das Ratsmash-Team."
						else
							if params[:persist]	
								cookies.permanent.signed[:at] = student.auth_token
							else
								cookies.signed[:at] = student.auth_token
							end
						end
					else
						error = "Das eingegebene Passwort ist falsch"
					end
				end
			else
				error = "Der Account konnte nicht gefunden werden"
			end

			if error
				respond_to do |format|
					format.html { flash[:notice] = error }
					format.json { render json: { status: :error, message: error } }
				end
			else
				respond_to do |format|
					format.html { redirect_to :home }
					format.json { render json: { status: :success } }
				end
			end
		end
	end

	def logout
		cookies.delete :at
		redirect_to :login
	end

	def reset_password
		if params[:email] and not ENV["launched"] == "no"
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
