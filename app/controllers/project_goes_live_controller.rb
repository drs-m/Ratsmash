class ProjectGoesLiveController < ApplicationController

	def index
		
	end

	def send_mails_to_students
		IO.read("students_names.txt").force_encoding("ISO-8859-1").encode("utf-8", replace: nil).each_line do |line|
			if Student.find_by_name(line)
				GoLiveMailer.send_first_mail_to_students(Student.find_by_name(line)).deliver
			end
		end

		redirect_to project_goes_live_index_path
	end

end