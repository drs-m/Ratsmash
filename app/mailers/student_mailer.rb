# encoding: utf-8
class StudentMailer < ActionMailer::Base
  default from: "from@example.com"

  def password_reset(student)
    @student = student
    mail to: student.mail_address, subject: "Passwort zurücksetzen"
  end

end
