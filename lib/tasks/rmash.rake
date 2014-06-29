namespace :rmash do

	desc "Initial mail delivery"
	task :launch_mail_delivery => :environment do

		# array für menschen aus dem informatik-kurs
		important = ["Darius Mewes", "Julius Rückin"]
 		results = Student.where name: important
		# results << Student.where password_digest = nil # alle anderen ohne passwort
		results.each do |student|
			student.send_launch_info_mail
		end

	end

	task :populate => :environment do
		File.read("students.txt").each_line do |line|
			name_data = line.rstrip.split(", ")
			name = name_data[1] + " " + name_data[0]
			email = (name.gsub(" ", ".") + "@rats-os.de").downcase
			puts name + " <#{email}>"
			gender_string = STDIN.gets.chomp
			next if gender_string == "d" # delete
			gender = gender_string == "m" # male
			Student.create name: name, mail_address: email, gender: gender
		end
	end

end
