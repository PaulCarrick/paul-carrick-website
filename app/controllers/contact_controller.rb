# app/controllers/contact_controller.rb
# frozen_string_literal: true

class ContactController < ApplicationController
  def new
  end

  def create
debugger
    @contact_params = post_comment_params
    @contact_params[:errors] = []

    unless verify_recaptcha(model: @contact_params)
      flash[:error] = "Recaptcha verification failed. Please try again."

      return redirect_to contact_url("failure", error: "Recaptcha verification failed")
    end

    begin
      # Send the email using ContactMailer
      ContactMailer.contact_email(
        @contact_params[:name],
        @contact_params[:email_address],
        @contact_params[:phone],
        @contact_params[:message]
      ).deliver_now

      flash[:info]  = "The contact information was successfully sent."
      redirect_path = contact_url("success")

      redirect_path.gsub!("http:", "https:")

      redirect_to redirect_path
    rescue => e
      flash[:alert] = "An error occurred sending the information: #{e.message}"
      redirect_path = contact_url("failure", error: e.message)

      redirect_path.gsub!("http:", "https:")

      redirect_to redirect_path
    end
  end

  def show
    @results = if params[:id] == "success"
                 "The contact information was successfully sent."
               else
                 "The contact information could not be sent: #{params[:error]}."
               end
  end

  private

  def post_comment_params
    params.permit(:name, :email_address, :phone, :message)
  end
end
