# encoding: utf-8
class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	# include symbol helper in all views
	helper :symbol

	def default_url_options
		Rails.env.production? ? {:host => "rmash.herokuapp.com"} : {}
 	end


	private
		# optionen: admin_permissions || redirect 
		def check_session(options = {})
			# wenn eine session vorhanden ist
			if cookies.signed[:at]
		 	 	# wenn current_user nicht gesetzt ist, finde ihn anhand des tokens in der datenbank
		 	 	if @current_user ||= Student.find_by(auth_token: cookies.signed[:at])
		 	 		# leite um wenn der user keine berechtigung hat
		    		redirect_to :home if options[:admin_permissions] && !@current_user.admin_permissions
		    	else
		    		# wenn zwar session[:acc_id] gesetzt ist, aber kein account gefunden wurde -> setze session zurück: redirect zu logout
		    		redirect_to :logout if options[:redirect]
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
