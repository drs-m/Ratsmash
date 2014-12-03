# encoding: utf-8
class StudentMailer < ActionMailer::Base
    default from: "Abizeitung & Ratsmash-Team <team@rmash.de>"
    
    def password_reset(student)
        @student = student
        mail to: student.mail_address, subject: "Passwort zurücksetzen"
    end

    def launch_info(student)
        @student = student
        mail to: student.mail_address, subject: "Aktiviere deinen Ratsmash-Account"
    end

end
