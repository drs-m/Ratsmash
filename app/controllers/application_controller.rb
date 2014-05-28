# encoding: utf-8
class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	# helper_method :check_session

	private
		def check_session(admin_permissions_required = false)
			# wenn eine session vorhanden ist
			if session[:acc_id]
		 	 	# wenn current_user nicht gesetzt ist, finde ihn anhand der id in der datenbank (find_by_id() statt find() um nil-exceptions zu vermeiden)
		 	 	if @current_user ||= Student.find_by_id(session[:acc_id])
		    		redirect_to :home if admin_permissions_required && !@current_user.admin_permissions
		    	else
		    		# wenn zwar session[:acc_id] gesetzt ist, aber kein account gefunden wurde -> setze session zurück: redirect zu logout
		    		redirect_to :logout
		    	end
		  	else
		  		# es ist keine session vorhanden --> user muss sich einloggen: weiterleitung
			  	redirect_to :login
		 	end
		end
end
