# encoding: utf-8
class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	# protect_from_forgery with: :exception

	# include symbol helper in all views
	helper :symbol
	helper_method :mobile_device?
	before_action :setOnlineStatus

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
					if options[:permission]
						permission = :required
						permission = :given if @current_user.has_permission(options[:permission])
					elsif options[:restricted_methods]
						if options[:restricted_methods].include?(params[:action].intern) or options[:restricted_methods].include?(:all)
							permission = :required
							permission = :given if @current_user.has_permission(params[:controller] + "." + params[:action])
						end
					end

					if permission == :required
						flash[:error] = "Du hast keine Berechtigung für diese Seite!"
						redirect_to options[:destination] || :home
					end
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

		# API Controllers

		def api_authentication
			api_authenticate_http_basic || render_unauthorized
		end

		def api_authenticate_http_basic
			authenticate_with_http_basic { |mail, password| Student.authenticate(mail, password) }
		end

		def render_unauthorized
			self.headers["WWW-Authenticate"] = 'Basic realm="Application"'
			render json: "Bad credentials", status: 401
		end

end
