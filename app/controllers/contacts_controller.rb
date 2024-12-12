# app/controllers/contacts_controller.rb

# frozen_string_literal: true

class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    begin
      @contact = Contact.create!(contact_params)

      # raise "Invalid Captcha." unless verify_recaptcha(model: @contact)

      ContactMailer.contact_email(@contact.name, @contact.email, @contact.phone, @contact.message).deliver_now

      @contact.submit_information = "The contactapp/controllers/contacts_controller.rb information was successfully sent."
      @contact.save!

      flash[:info] = @contact.submit_information

      redirect_to contact_path(@contact)
    rescue ActiveRecord::RecordNotUnique => e
      @error_message = "You cannot submit the form twice with the exact same information. Please at least change the message."
      flash[:error]  = @error_message

      if @contact.present?
        @contact.submit_information = @error_message
        @contact.save
      end

      redirect_to action: :new, notice: "There are error in the form. Please try again."
    rescue => e
      debugger if Rails.env == 'development' && ENV["PAUSE_ERRORS"]

      @error_message = @contact&.errors&.full_messages&.join(", ")
      @error_message = e&.message unless @error_message.present?
      flash[:error]  = @error_message

      if @contact.present?
        @contact.submit_information = @error_message
        @contact.save
      end

      redirect_to action: :new, notice: "There are error in the form. Please try again."
    end
  end

  def show
    @contact = Contact.find(params[:id])
    @results = @contact.submit_information
  end

  private

  def contact_params
    params.require(:contact).permit(:id, :name, :email, :phone, :message)
  end
end
