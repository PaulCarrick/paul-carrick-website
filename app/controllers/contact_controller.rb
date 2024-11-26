# app/controllers/contact_controller.rb
# frozen_string_literal: true

class ContactController < ApplicationController
  def new
  end

  def create
    #    if verify_recaptcha(model: @contact)
    begin
      mailer = ContactMailer.new

      mailer.contact_email(params[:name], params[:email_address], params[:phone], params[:message]).deliver_now

      @notice = "The contact information was successfully sent."
      flash[:info] = notice

      respond_to do |format|
        format.html { redirect_to contact_url("success") }
      end
    rescue => e
      format.html { redirect_to contact_url("failure", error: e.message) }
    end
  end

  def show
    if params[:id] == "success"
      @results = "The contact information was successfully sent."
    else
      @results = "The contact information could not be sent: #{params[:error]}."
    end
  end

  private

  def post_comment_params
    params.require(:comment).permit(:name, :email_address, :phone, :message)
  end
end
