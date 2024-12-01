# app/controllers/admin/users_controller.rb
class Admin::UsersController < ApplicationController
  include Pagy::Backend

  #  before_action :authenticate_user! # Ensure only authenticated users can access
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :check_admin

  def check_admin
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end

  def index
    @q = User.ransack(params[:q]) # Initialize Ransack search object

    # Set default sort column and direction
    sort_column = params[:sort].presence || "email"
    sort_direction = params[:direction].presence || "asc"

    # Safeguard against invalid columns and directions
    sort_column = User.column_names.include?(sort_column) ? sort_column : "email"
    sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : "asc"

    # Combine sorting and Ransack results
    sorted_results = @q.result(distinct: true).order("#{sort_column} #{sort_direction}")

    # Paginate the sorted results
    @pagy, @users = pagy(sorted_results, limit: 20)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "User created successfully."
    else
      render :new, alert: "Error creating user."
    end
  end

  def edit
  end

  def update
    # Add logic to update the user
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted successfully."
  end

  private

  def set_user
byebug
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :admin, :super, :roles) # Add :role if you have roles
  end
end
