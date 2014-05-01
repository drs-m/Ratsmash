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




# Schüler
students = [["Darius Mewes", true, "darius.mewes@rats-os.de", true, "test123"], ["Max Mustermann", true, "max.mustermann@rats-os.de", false, "hihi"], ["Julius Rückin", true, "julius.rückin@rats-os.de", true, "fladenbrot"], ["Inactiva Scholtz", false, "bumm@dong.de", false, "zinzon"]]
students.each { |student| Student.create name: student[0], gender: student[1], mail_address: student[2], admin_permissions: student[3], password: student[4], password_confirmation: student[4] }
Student.find(4).update password_resetkey: SecureRandom.urlsafe_base64

# Lehrer
teachers = [["Lisa Müller", false], ["Hans-Christian Schmidt", true], ["Florian Obstkorb", true], ["Klarissa Kuh", false], ["Megan Schnase", false], ["Klaus-Markus König", true], ["Christina Tosko", false]]
teachers.each { |teacher| Teacher.create name: teacher[0], gender: teacher[1] }
