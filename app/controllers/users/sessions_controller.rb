# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :custom_redirect, only: [ :new, :create ]

  private

  def custom_redirect
    if signed_in?
      if current_user.admin?
        redirect_to admin_root_path, turbo: false
      else
        redirect_to root_path(data: current_user.as_json), turbo: false
      end
    end
  end
end
