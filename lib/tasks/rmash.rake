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

	task :setup_groups => :environment do
		Group.create name: "Alle", female: true, male: true, student: true, teacher: true
		Group.create name: "Alle Frauen", female: true, student: true, teacher: true
		Group.create name: "Alle Männer", male: true, student: true, teacher: true
		Group.create name: "Alle Schüler", female: true, male: true, student: true
		Group.create name: "Alle Lehrer", female: true, male: true, teacher: true
		Group.create name: "Schüler", male: true, student: true
		Group.create name: "Schülerinnen", female: true, student: true
		Group.create name: "Lehrer", male: true, teacher: true
		Group.create name: "Lehrerinnen", female: true, teacher: true
	end

end
