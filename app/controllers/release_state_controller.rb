# encoding: utf-8
class ReleaseStateController < ApplicationController

	before_action -> { check_session redirect: true, admin_permissions: true }

	def index
		
	end

	def send_mails_to_students
		# muss hier geladen werden, da environment.rb nur beim starten ausgeführt wird
		settings_path = Rails.root + "config" + "settings.yml"
		settings = YAML.load_file settings_path

		if !settings
			flash['notice'] = "Fehler: settings.yml wurde nicht gefunden"
			return
		end

		if !settings["launch"]["released"]
			settings["launch"]["released"] = true
			settings["launch"]["xpos"] = params[:xpos]
			settings["launch"]["ypos"] = params[:ypos]
			# speichern
			File.open(settings_path, "w") { |f| f.write settings.to_yaml }
			IO.read("students_names.txt").force_encoding("utf-8").each_line do |line|
				line = line.rstrip # remove trailing whitespace
				student = Student.find_by name: line
				ReleaseStateMailer.send_first_mail_to_students(student).deliver if student
			end
		end

		redirect_to release_state_index_path
	end

	def get_mail_status
		settings_path = Rails.root + "config" + "settings.yml"
		settings = YAML.load_file settings_path

		if settings["launch"]["released"]
			status = true 
			xpos = settings["launch"]["xpos"]
			ypos = settings["launch"]["ypos"]
		else
			status = false
		end

		respond_to do |format|
		  	format.json { render json: [status, xpos.to_i, ypos.to_i] }
		end
	end

	def reset
		settings_path = Rails.root + "config" + "settings.yml"
		settings = YAML.load_file settings_path
		settings["launch"]["released"] = false
		File.open(settings_path, "w") { |f| f.write settings.to_yaml }
		redirect_to release_state_index_path
	end

end
