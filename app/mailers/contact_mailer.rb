class ContactMailer < ApplicationMailer
  default to: "carrick.paul.jeffrey@gmail.com"
  default subject: "New Contact Form Submission from paul-carrick.com"
  default from: "info@paul-carrick.com"

  def contact_email(name, email, phone, message)
    @sender_email = email
    @sender_name = name
    @sender_phone = phone
    @sender_message = message
    mail(to: "carrick.paul.jeffrey@gmail.com",
         from: "info@paul-carrick.com",
         subject: "Contact Request") do |format|
      format.html # Ensure it looks for `contact_email.html.erb`
    end
  end
end
