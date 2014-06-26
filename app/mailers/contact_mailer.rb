class ContactMailer < ActionMailer::Base
    default from: "rmashteam@gmail.com"

    def send_contact_mail(name,from_mail,to_mail,subject,message)
    	@name = name
    	@from_mail = from_mail
    	@subject = subject
    	@message = message
    	mail to: to_mail, subject: "Ratsmash-Team - " + subject
    end

end
