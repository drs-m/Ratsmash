# encoding: utf-8
class ContactMailer < ActionMailer::Base
    default from: "RMash Kontaktformular <team@rmash.de>"

    def send_mail(name, sender_address, subject, message)
        @name = name
        @sender_address = sender_address
        @subject = subject
        @message = message

        mail to: "team@rmash.de", subject: ("Kontaktformular: " + subject)
    end

end
