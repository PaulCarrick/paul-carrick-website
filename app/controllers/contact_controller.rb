# app/controllers/contact_controller.rb
# frozen_string_literal: true

class ContactController < ApplicationController
  def new
  end

  def create
    #    if verify_recaptcha(model: @contact)
    begin
      mailer = ContactMailer.new

      mailer.contact_email(params[:name], params[:email_address], params[:phone], params[:message])

      @notice = "Contact form was successfully sent."
      flash[:info] = notice

      respond_to do |format|
        format.html { redirect_to root_url(target: "_self"), notice: @notice }
      end
    rescue => e
      @notice = "Could not send email. Error: #{e.message}."
      flash[:error] = notice
    end
  end

  private

  def post_comment_params
    params.require(:comment).permit(:name, :email_address, :phone, :message)
  end
end
