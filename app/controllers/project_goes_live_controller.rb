class ProjectGoesLiveController < ApplicationController

	def index

	end

	def send_mails_to_students
		if GoLive.all.count > 0
			status = GoLive.all.last.send_mails 
		else
			status = false
		end

		if !status
			GoLive.create :send_mails => true, :xpos => params[:xpos], :ypos => params[:ypos]
			IO.read("students_names.txt").force_encoding("ISO-8859-1").encode("utf-8", replace: nil).each_line do |line|
				if Student.find_by_name(line)
					GoLiveMailer.send_first_mail_to_students(Student.find_by_name(line)).deliver
				end
			end
		end

		redirect_to project_goes_live_index_path
	end

	def get_mail_status
		data = []
		if GoLive.all.count > 0
			status = GoLive.all.last.send_mails 
			xpos = GoLive.all.last.xpos
			ypos = GoLive.all.last.ypos
		else
			status = false
		end
		data[0] = status
		data[1] = xpos
		data[2] = ypos

		respond_to do |format|
		  	format.json { render :json => data }
		end
	end

end