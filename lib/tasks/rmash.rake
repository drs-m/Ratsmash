# encoding: utf-8

namespace :rmash do

	task :mirror_db => :environment do
		require "net/http"
		require "uri"

		host = "http://api.dariusmewes.de/"
		api_version = 1

		puts "Lösche Datenbank..."
		Rake::Task["db:drop"].invoke
		puts "Erstelle neue Datenbank..."
		Rake::Task["db:create"].invoke
		puts "Erstelle neue Tabellen..."
		Rake::Task["db:migrate"].invoke
		puts "Erstelle Gruppen..."
		Rake::Task["rmash:setup_groups"].invoke

		puts "Importiere Daten von #{host} ..."
		puts "Bitte gib deine E-Mail Adresse ein:"
		email = STDIN.gets.chomp
		puts "Bitte gib dein Passwort ein:"
		password = STDIN.gets.chomp

		error = false

		[:students, :categories].each do |type|
			uri = URI.parse(host + "v#{api_version.to_s}/#{type.to_s}")
			http = Net::HTTP.new(uri.host, uri.port)
			request = Net::HTTP::Get.new(uri.request_uri)
			request.basic_auth email, password
			response = http.request(request)
			if response.code == "200"
				json = JSON.parse(response.body)
				json.each do |entry|
					if type == :students
						student_data = {}
						student_data.merge!({ name: entry["name"] })
						student_data.merge!({ mail_address: entry["mail_address"] })
						student_data.merge!({ password_digest: entry["password_digest"] })
						student_data.merge!({ gender: entry["gender"] })
						student_data.merge!({ closed: entry["closed"] })
						student_data.merge!({ admin_permissions: entry["admin_permissions"] })
						student = Student.new student_data
						student.valid? ? student.save : puts(student.errors.messages)
					elsif type == :categories
						category_data = { name: entry["name"], group_id: entry["group_id"], closed: entry["closed"] }
						category = Category.new category_data
						category.valid? ? category.save : puts(category.errors.messages)
					end
				end
			else
				error = true
			end
		end
		puts(error ? "Die eingegebenen Daten sind nicht korrekt!" : "#{Category.count} Kategorien und #{Student.count} Schüler wurden hinzugefügt!")
	end

	desc "Initial mail delivery"
	task :launch_mail_delivery => :environment do
		puts "[#{Time.now}] Sending emails..."
		important = ["Darius Mewes"]
		results = Student.where name: important if not important.empty?
		# results << Student.where(password_digest: nil).where.not(name: important) # NICHT AUSKOMMENTIEREN!!!

		began = Time.now

		results.each do |student|
			student.send_launch_info_mail
		end

		diff = Time.now - began
		minutes = (diff / 60).to_i
		seconds = (diff % 60).to_i
		puts "[#{Time.now}] Mail sending finished. Took #{minutes}:#{seconds}"
	end

	task :import_json, [:model_name] => [:environment] do |t, args|
		args[:model_name]
		if args[:model_name].blank?
			puts "Bitte gib einen Dateinamen an!"
		else
			model_name = args[:model_name]
			model = (model_name.to_s.singularize.capitalize.constantize)
			model.destroy_all
			puts "Tabelle geleert"
			before = model.count
			data = JSON.parse(File.read(model_name + ".json"))
			data.each do |entity_data|
				model.create entity_data
			end
			puts (model.count - before).to_s + " Datensätze hinzugefügt"
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

	task :clear_table, [:model_name] => :environment do |t, args|
		deleted_entries = (args[:model_name].to_s.singularize.capitalize.constantize).delete_all
		puts deleted_entries.to_s + " Einträge gelöscht!"
	end

	task :generate_votes => :environment do
		began = Time.now
		count = 0
		Student.all.each do |voter|
			Student.all.each do |voted|
				vote = voter.given_votes.build
				vote.rating = rand(1..3)
				vote.voted_type = "Student"
				vote.voted_id = voted.id
				random_category = Category.find Group.all_students.categories.sample
				vote.category_id = random_category.id
				vote.save
				count += 1
				puts "#{count}. Vote erstellt: #{voter.name} -> #{voted.name} | #{random_category.name}"
			end
		end

		diff = Time.now - began
		minutes = (diff / 60).to_i
		seconds = (diff % 60).to_i
		puts "[#{Time.now}] Votes generated. Took #{minutes}:#{seconds}"
	end

	task :setup_groups => :environment do
		Group.destroy_all
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
