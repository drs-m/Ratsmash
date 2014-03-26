# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Kategorien für Schüler
categories_student = ["Toll", "Schön", "Schlau", "Nett", "Blabla"]
categories_student.each { |cp_name| Category.create name: cp_name}

# Kategorien für Lehrer
categories_teacher = ["Streng", "Tollpatschig", "Nett", "Kompetent", "Schön"]
categories_teacher.each { |ct_name| Category.create name: ct_name, applies_to_teacher: true }

# Schüler
students = [["Darius", "Mewes", true, "darius.mewes@rats-os.de", true], ["Max", "Mustermann", true, "max.mustermann@rats-os.de", true], ["Julius", "Rückin", true, "julius.rückin@rats-os.de", true]]
students.each { |student| Student.create first_name: student[0], last_name: student[1], gender: student[2], mail_address: student[3], admin_permissions: student[4] }

# Lehrer
teachers = [["Lisa", "Müller", false], ["Hans-Christian", "Schmidt", true], ["Florian", "Obstkorb", true], ["Klarissa", "Kuh", false], ["Megan", "Schnase", false], ["Klaus-Markus", "König", true], ["Christina", "Tosko", false]]
teachers.each { |teacher| Teacher.create first_name: teacher[0], last_name: teacher[1], gender: teacher[2] }
