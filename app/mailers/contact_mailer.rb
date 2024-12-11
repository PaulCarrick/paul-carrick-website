class ContactMailer < ApplicationMailer
  default to: "carrick.paul.jeffrey@gmail.com",
          from: "paul@paul-carrick.com",
          subject: "New Contact Form Submission from #{@site_information.site_name}"

  def contact_email(name, email, phone, message)
    @sender_email = email
    @sender_name = name
    @sender_phone = phone
    @sender_message = message

    mail do |format|
      format.html # This looks for a `contact_email.html.erb` template
    end
  end
end
