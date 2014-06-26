class GoLiveMailer < ActionMailer::Base
  	default from: "from@example.com"

  	def send_first_mail_to_students(student)
  		@student = student
  		mail to: student.mail_address, subject: "Beginne mit Ratsmash"
  	end

end
