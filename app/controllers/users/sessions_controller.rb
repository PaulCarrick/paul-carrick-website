# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :custom_redirect, only: [:new, :create]

  private

  def custom_redirect
    if user_signed_in?
      redirect_to admin_root_path, turbo: false
      return
    end
  end
end
