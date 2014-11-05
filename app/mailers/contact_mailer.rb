class ContactMailer < ActionMailer::Base
    default from: "team@dariusmewes.de"

    def send_mail(name, sender_address, subject, message)
    	@name = name
    	@sender_address = from_mail
    	@subject = subject
    	@message = message
        recipient_address = "team@dariusmewes.de"

        mail to: recipient_address, subject: "Kontaktformular: " + subject
    end

end
