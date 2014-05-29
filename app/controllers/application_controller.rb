# encoding: utf-8
class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	# helper_method :check_session

	private
		def check_session(options = {})
			# wenn eine session vorhanden ist
			if cookies[:at]
		 	 	# wenn current_user nicht gesetzt ist, finde ihn anhand des tokens in der datenbank
		 	 	if @current_user ||= Student.find_by(auth_token: cookies[:at])
		 	 		# leite um wenn der user keine berechtigung hat
		    		redirect_to :home if options[:admin_permissions] && !@current_user.admin_permissions
		    	else
		    		# wenn zwar session[:acc_id] gesetzt ist, aber kein account gefunden wurde -> setze session zurück: redirect zu logout
		    		redirect_to :logout if options[:redirect]
		    	end
		  	else
		  		# es ist keine session vorhanden --> user muss sich einloggen: weiterleitung
			  	redirect_to :login if options[:redirect]
		 	end
		end
end
