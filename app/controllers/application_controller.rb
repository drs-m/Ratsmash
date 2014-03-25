# encoding: utf-8
class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	helper_method :check_session


	private
		def check_session
			# wenn eine session vorhanden ist
			if session[:acc_id]
		 	 	# wenn u_account nicht gesetzt ist, finde ihn anhand der id in der datenbank (find_by_id() statt find() um nil-exceptions zu vermeiden)
		 	 	@u_account ||= Account.find_by_id(session[:acc_id])
		    	# wenn der account nicht vorhanden ist, setze die aktuelle session zurück (redirect zur logout)
		    	return redirect_to controller: "session", action: "logout" if @u_account.nil?
		    	# setze profil-variable für leichteren zugriff
		    	@u_profile = @u_account.profile
		  	else
		  		# es ist keine session vorhanden --> user muss sich einloggen: weiterleitung
			  	redirect_to controller: "session", action: "login"
		 	end
	end

end
