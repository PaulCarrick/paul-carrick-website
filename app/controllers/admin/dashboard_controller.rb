class Admin::DashboardController < ApplicationController
  before_action :authenticate_user! # Require login for admin functions
  before_action :require_admin # Ensure the user is an admin

  def index
    # Admin dashboard logic
  end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
