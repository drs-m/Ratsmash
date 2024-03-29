# encoding: utf-8

Group.create name: "Alle", female: true, male: true, student: true, teacher: true
Group.create name: "Alle Frauen", female: true, student: true, teacher: true
Group.create name: "Alle Männer", male: true, student: true, teacher: true
Group.create name: "Alle Schüler", female: true, male: true, student: true
Group.create name: "Alle Lehrer", female: true, male: true, teacher: true
Group.create name: "Schüler", male: true, student: true
Group.create name: "Schülerinnen", female: true, student: true
Group.create name: "Lehrer", male: true, teacher: true
Group.create name: "Lehrerinnen", female: true, teacher: true
puts Group.count.to_s + " Gruppen wurden erstellt!"

# Kategorien
student_categories = ["Toll",  "Schön",  "Schlau", "Nett", "Tollpatschig", "Kompetent"]
Group.all.each do |group|
	student_categories.each { |category| Category.create name: category, group_id: group.id }
	Category.create name: group.name, group_id: group.id
end
puts Category.count.to_s + " Kategorien wurden erstellt!"

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
