# app/controllers/contact_controller.rb
# frozen_string_literal: true

class ContactController < ApplicationController
  def new
  end

  def create
    #    if verify_recaptcha(model: @contact) && @contact.save
    if @contact.save
      begin
        mailer = ContactMailer.new

        mailer.send_email(params[:name], params[:email_address], params[:phone], params[:message])

        @notice = 'Conact form was successfully sent.'
        flash[:info] = notice
      rescue => e
        @notice = "Could not send email. Error: #{e.message}."
        flash[:error] = notice
      end

      respond_to do |format|
        format.html { redirect_to root_path, notice: @notice }
      end

      redirect_to root_path, notice: 'Your message has been sent successfully.'
    else
      flash.now[:alert] = 'There was an error with your submission. Please try again.'
      render :new
    end
  end

  private

  def post_comment_params
    params.require(:comment).permit(:name, :email_address, :phone, :message)
  end
end
