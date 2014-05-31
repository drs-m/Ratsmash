# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Kategorien für alle Schüler (IDs: 1-5)
categories_pupil_all = ["Toll",  "Schön",  "Schlau", "Nett", "Blabla"]
categories_pupil_all.each { |cp_name| Category.create(name: cp_name).apply_to(:all_students) }

# Kategorien für männliche Schüler (IDs: 6-10)
categories_pupil_male = ["Toll", "Schön", "Schlau", "Nett", "Blabla"]
categories_pupil_male.each { |cp_name| Category.create(name: cp_name).apply_to(:male_students) }

#Kategorien für weibliche Schüler (IDs: 11-15)
categories_pupil_female = ["Toll", "Schön", "Schlau", "Nett", "Blabla"]
categories_pupil_female.each { |cp_name| Category.create(name: cp_name).apply_to(:female_students) }


#Kategorien für alle Lehrer (IDs: 16-20)
categories_teacher_all = ["Streng", "Tollpatschig", "Nett", "Kompetent", "Schön"]
categories_teacher_all.each { |ct_name| Category.create(name: ct_name).apply_to(:all_teachers) }

# Kategorien für Lehrer (IDs: 21-25)
categories_teacher_male = ["Streng", "Tollpatschig", "Nett", "Kompetent", "Schön"]
categories_teacher_male.each { |ct_name| Category.create(name: ct_name).apply_to(:male_teachers) }

# Kategorien für Lehrerinnen (IDs: 26-30)
categories_teacher_female = ["Streng", "Tollpatschig", "Nett", "Kompetent", "Schön"]
categories_teacher_female.each { |ct_name| Category.create(name: ct_name).apply_to(:female_teachers) }

# Kategorien für Alle (IDs: 31-35)
categories_all = ["Toll", "Schön", "Schlau", "Nett", "Blabla"]
categories_all.each { |cp_name| Category.create(name: cp_name).apply_to(:all) }

#Kategorien für alle Männer (IDs: 36-40)
categories_all_male = ["Toll", "Schön", "Schlau", "Nett", "Blabla"]
categories_all_male.each { |cp_name| Category.create(name: cp_name).apply_to(:all_male) }

#Kategorien für alle Frauen (IDs: 41-45)
categories_all_female = ["Toll", "Schön", "Schlau", "Nett", "Blabla"]
categories_all_female.each { |cp_name| Category.create(name: cp_name).apply_to(:all_female) }


first_names_female = ["Karin", "Jessica", "Krista", "Laura", "Marianne", "Floriane", "Tusnelda", "Kassandra"]
first_names_male = ["Thomas", "Peter", "Christoph", "Joe", "Sean", "Tobias", "Hendrik", "Carlo"]
last_names = ["Schmidt", "Meier", "Müller", "Schulz", "Boden", "Bago", "Gutt", "Knöff"]

# Schüler
students = [["Darius Mewes", true, "darius.mewes@rats-os.de", true, "test123"], ["Max Mustermann", true, "max.mustermann@rats-os.de", false, "hihi"], ["Julius Rückin", true, "julius.rueckin@rats-os.de", true, "fladenbrot"], ["Inactiva Scholtz", false, "bumm@dong.de", false, "zinzon"]]
students.each { |student| Student.create name: student[0], gender: student[1], mail_address: student[2], admin_permissions: student[3], password: student[4], password_confirmation: student[4] }
Student.find(4).update closed: true

# more students
last_names.each do |last_name|
	first_names_female.each  { |first_name| Student.create name: "#{first_name} #{last_name}", gender: false, mail_address: "#{first_name}.#{last_name}@rats-os.de".downcase, password: "pw", password_confirmation: "pw" }
	first_names_male.each { |first_name| Student.create name: "#{first_name} #{last_name}", gender: true, mail_address: "#{first_name}.#{last_name}@rats-os.de".downcase, password: "pw", password_confirmation: "pw" }
end

# Lehrer
teachers = [["Lisa Müller", false], ["Hans-Christian Schmidt", true], ["Florian Obstkorb", true], ["Klarissa Kuh", false], ["Megan Schnase", false], ["Klaus-Markus König", true], ["Christina Tosko", false]]
teachers.each { |teacher| Teacher.create name: teacher[0], gender: teacher[1] }

# Votes für max mustermann
max = Student.find_by(name: "Max Mustermann")
Student.all.each do |student|
	rating = rand(1..3)
	max.achieved_votes << student.given_votes.build(category_id: 1, rating: rating)
	puts student.name + " hat eine Stimme für Max abgegeben (Kategorie: Toll, Rating: #{rating})"
end
