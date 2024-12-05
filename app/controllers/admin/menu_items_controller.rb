class Admin::MenuItemsController < ApplicationController
  include Pagy::Backend

  before_action :set_menu_item, only: %i[show edit update destroy]

  def index
    sort_column = params[:sort] || 'label' # Default sorting column
    sort_direction = params[:direction] || 'asc' # Default sorting direction
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
