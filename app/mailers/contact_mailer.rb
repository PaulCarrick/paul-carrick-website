class ContactMailer < ApplicationMailer
  default to: 'carrick.paul.jeffrey@gmail.com'
  default subject: 'New Contact Form Submission from paul-carrick.com'
  default from: 'info@paul-carrick.com'

  def contact_email(name, email, phone, message)
    @sender_email = email
    @sender_name = name
    @sender_phone = phone
    @sender_message = message
    message = mail

    message.deliver!
  end
end
