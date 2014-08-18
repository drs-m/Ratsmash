# encoding: utf-8
class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	# include symbol helper in all views
	helper :symbol
	helper_method :mobile_device?
	before_filter :setOnlineStatus

 	def setOnlineStatus
 		if logged_in?
 			@current_user.update_attributes :last_seen_at => Time.now
 		end
 	end

	private
		def mobile_device?
			request.user_agent =~ /Mobile|webOS|Android|PlayBook|Kindle|Kindle Fire|Windows Phone/
		end

		# optionen: admin_permissions || redirect
		def check_session(options = {})
			# wenn eine session vorhanden ist
			if cookies.signed[:at]
		 	 	# wenn current_user nicht gesetzt ist, finde ihn anhand des tokens in der datenbank
		 	 	if @current_user ||= Student.find_by(auth_token: cookies.signed[:at])
		 	 		# leite um wenn der user keine berechtigung hat
		    		redirect_to options[:destination] || :home if options[:admin_permissions] && !@current_user.admin_permissions
		    	else
		    		# wenn zwar session[:acc_id] gesetzt ist, aber kein account gefunden wurde -> setze session zurück: redirect zu logout
		    		redirect_to options[:destination] || :logout if options[:redirect]
		    	end
		  	else
		  		redirect_to :login and return if options[:redirect] # es ist keine session vorhanden --> user muss sich einloggen: weiterleitung
		 	end
		 	#Zeitzone setzten bzw. Zeitverschiebung zu UTC
		 	@timezone = 2
		end

		def logged_in?
			check_session redirect: false
			return @current_user.present?
		end

end
