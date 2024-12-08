class Admin::MenuItemsController < ApplicationController
  include Pagy::Backend

  before_action :set_menu_item, only: %i[show edit update destroy]

  def index
    if params[:sort].present?
      session[:menu_items_sort] = params[:sort]
    elsif session[:menu_items_sort].present?
      params[:sort] = session[:menu_items_sort]
    else
      params[:sort] = nil
    end

    if params[:direction].present?
      session[:menu_items_sort_direction] = params[:direction]
    elsif session[:menu_items_sort_direction].present?
      params[:direction] = session[:menu_items_sort_direction]
    else
      params[:direction] = nil
    end

    # Set default sort column and direction
    sort_column = params[:sort].presence || "label"
    sort_direction = params[:direction].presence || "asc"

    # Safeguard against invalid columns and directions
    sort_column = MenuItem.column_names.include?(sort_column) ? sort_column : "label"
    sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : "asc"
    @pagy, @menus = pagy(MenuItem.order("#{sort_column} #{sort_direction}"), limit: 30)
  end

  def show
  end

  def new
    @menu_item = MenuItem.new
    @menus = MenuItem.all
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)

    if @menu_item.save
      redirect_to admin_menu_items_path, notice: "MenuItem created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @menu_item.update(menu_item_params)
      redirect_to admin_menu_items_path, notice: "MenuItem updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @menu_item.destroy
    redirect_to admin_menu_items_path, notice: "MenuItem deleted successfully."
  end

  private

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
    @menus = MenuItem.all
  end

  def menu_item_params
    params.require(:menu_item).permit(:menu_type, :label, :icon, :options, :access, :link, :menu_order, :parent_id)
  end
end
