class ContactMailer < ActionMailer::Base
    default from: "no-reply@rmash.com"

    def send_contact_form(mail,subject)
    	mail(to: mail, subject: subject)
    end

end
