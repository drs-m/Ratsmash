namespace :rmash do

	desc "Initial mail delivery"
	task :launch_mail_delivery => :environment do

		# array für menschen aus dem informatik-kurs
		important = [1,3]
 		results = Student.where id: important
		# results << Student.where password_digest = nil # alle anderen ohne passwort
		results.each do |student|
			student.send_launch_info_mail
		end

	end

end
