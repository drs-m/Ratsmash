class ReleaseStateController < ApplicationController

	# before_action -> { check_session redirect: true, admin_permissions: true }

	def index
		
	end

	def send_mails_to_students
		if RELEASE_STATE_CONFIG["sended_first_mail_to_students"]
			status = true 
		else
			status = false
		end

		if !status
			RELEASE_STATE_CONFIG["sended_first_mail_to_students"] = true
			RELEASE_STATE_CONFIG["xpos"] = params[:xpos]
			RELEASE_STATE_CONFIG["ypos"] = params[:ypos]
			IO.read("students_names.txt").force_encoding("ISO-8859-1").encode("utf-8", replace: nil).each_line do |line|
				if Student.find_by_name(line)
					ReleaseStateMailer.send_first_mail_to_students(Student.find_by_name(line)).deliver
				end
			end
		end

		redirect_to release_state_index_path
	end

	def get_mail_status
		data = []
		if RELEASE_STATE_CONFIG["sended_first_mail_to_students"]
			status = true 
			xpos = RELEASE_STATE_CONFIG["xpos"]
			ypos = RELEASE_STATE_CONFIG["ypos"]
		else
			status = false
		end
		data[0] = status
		data[1] = xpos.to_i
		data[2] = ypos.to_i

		respond_to do |format|
		  	format.json { render :json => data }
		end
	end

end