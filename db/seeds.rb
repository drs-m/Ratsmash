# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Kategorien für alle Schüler
categories_pupil_all = ["Toll", "Schön", "Schlau", "Nett", "Blabla"]
categories_pupil_all.each { |cp_name| Category.create(name: cp_name).apply_to(:all_students) }

# Kategorien für männliche Schüler
categories_pupil_male = ["Toll", "Schön", "Schlau", "Nett", "Blabla"]
categories_pupil_male.each { |cp_name| Category.create(name: cp_name).apply_to(:male_students) }

#Kategorien für weibliche Schüler
categories_pupil_female = ["Toll", "Schön", "Schlau", "Nett", "Blabla"]
categories_pupil_female.each { |cp_name| Category.create(name: cp_name).apply_to(:female_students) }


#Kategorien für alle Lehrer
categories_teacher_all = ["Streng", "Tollpatschig", "Nett", "Kompetent", "Schön"]
categories_teacher_all.each { |ct_name| Category.create(name: ct_name).apply_to(:all_teachers) }

# Kategorien für Lehrer
categories_teacher_male = ["Streng", "Tollpatschig", "Nett", "Kompetent", "Schön"]
categories_teacher_male.each { |ct_name| Category.create(name: ct_name).apply_to(:male_teachers) }

# Kategorien für Lehrerinnen
categories_teacher_female = ["Streng", "Tollpatschig", "Nett", "Kompetent", "Schön"]
categories_teacher_female.each { |ct_name| Category.create(name: ct_name).apply_to(:female_teachers) }

# Kategorien für Alle
categories_all = ["Toll", "Schön", "Schlau", "Nett", "Blabla"]
categories_all.each { |cp_name| Category.create(name: cp_name).apply_to(:all) }

#Kategorien für alle Männer
categories_all_male = ["Toll", "Schön", "Schlau", "Nett", "Blabla"]
categories_all_male.each { |cp_name| Category.create(name: cp_name).apply_to(:all_male) }

#Kategorien für alle Frauen
categories_all_female = ["Toll", "Schön", "Schlau", "Nett", "Blabla"]
categories_all_female.each { |cp_name| Category.create(name: cp_name).apply_to(:all_female) }




# Schüler
students = [["Darius", "Mewes", true, "darius.mewes@rats-os.de", true, "test123"], ["Max", "Mustermann", true, "max.mustermann@rats-os.de", false, "hihi"], ["Julius", "Rückin", true, "julius.rückin@rats-os.de", true, "fladenbrot"], ["Inactiva", "Scholtz", false, "bumm@dong.de", false, "zinzon"]]
students.each { |student| Student.create first_name: student[0], last_name: student[1], gender: student[2], mail_address: student[3], admin_permissions: student[4], password: student[5], password_confirmation: student[5] }
Student.find(4).update password_resetkey: SecureRandom.urlsafe_base64

# Lehrer
teachers = [["Lisa", "Müller", false], ["Hans-Christian", "Schmidt", true], ["Florian", "Obstkorb", true], ["Klarissa", "Kuh", false], ["Megan", "Schnase", false], ["Klaus-Markus", "König", true], ["Christina", "Tosko", false]]
teachers.each { |teacher| Teacher.create first_name: teacher[0], last_name: teacher[1], gender: teacher[2] }
