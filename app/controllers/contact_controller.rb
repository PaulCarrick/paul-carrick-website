# app/controllers/contact_controller.rb
# frozen_string_literal: true

class ContactController < ApplicationController
  def new
  end

  def create
byebug
    @contact_params = post_comment_params

    # Uncomment this block if using Recaptcha
    # unless verify_recaptcha(model: @contact_params)
    #   flash[:alert] = "Recaptcha verification failed. Please try again."
    #   return redirect_to contact_url("failure", error: "Recaptcha verification failed")
    # end

    begin
      # Send the email using ContactMailer
      ContactMailer.contact_email(
        @contact_params[:name],
        @contact_params[:email_address],
        @contact_params[:phone],
        @contact_params[:message]
      ).deliver_now

      flash[:info] = "The contact information was successfully sent."

      render :new
    rescue => e
      flash[:alert] = "An error occurred: #{e.message}"

      render :new
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
