# encoding: utf-8
class SessionController < ApplicationController

	def login
		# redirect if logged in
		redirect_to :home and return if logged_in?

		# form sent?
		if params[:email] # and request.post?
			if (response = Student.login(params[:email], params[:password]))[:status] == :success
				Login.create user_id: response[:user].id, mobile_device: mobile_device?
				if params[:persistent]
					cookies.permanent.signed[:at] = response[:user].auth_token
				else
					cookies.signed[:at] = response[:user].auth_token
				end

				respond_to do |f|
					f.html { redirect_to :home }
					f.json { render json: { status: :success, path: session[:destination] || "/" }}
				end
			else
				respond_to do |f|
					f.html { flash[:error] = response[:message] }
					f.json { render json: response }
				end
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
				if student.closed or student.password_digest.blank?
					@closed_error = true
				else
					student.send_password_help_mail if student
					@success = true
				end
			end
		end
	end

end
