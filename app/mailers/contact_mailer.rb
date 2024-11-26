class ContactMailer < ApplicationMailer
  default to: "carrick.paul.jeffrey@gmail.com",
          from: "paul@paul-carrick.com",
          subject: "New Contact Form Submission from paul-carrick.com"

  def contact_email(name, email, phone, message)
    @sender_email = email
    @sender_name = name
    @sender_phone = phone
    @sender_message = message

    mail do |format|
      format.html { redirect_to contact_url("success") } # For non-AJAX
      format.json { render json: { message: "Success" }, status: :ok } # For AJAX
    end
  end
end
