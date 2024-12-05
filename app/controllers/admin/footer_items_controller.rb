class Admin::FooterItemsController < ApplicationController
  include Pagy::Backend

  before_action :set_footer_item, only: %i[show edit update destroy]

  def index
    sort_column = params[:sort] || 'label' # Default sorting column
    sort_direction = params[:direction] || 'asc' # Default sorting direction
    @pagy, @footers = pagy(FooterItem.order("#{sort_column} #{sort_direction}"), limit: 30)
  end

  def show
  end

  def new
    @footer_item = FooterItem.new
    @footers = FooterItem.all
  end

  def create
    @footer_item = FooterItem.new(footer_item_params)

    if @footer_item.save
      redirect_to admin_footers_path, notice: "FooterItem created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @footer_item.update(footer_item_params)
      redirect_to admin_footers_path, notice: "FooterItem updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @footer_item.destroy
    redirect_to admin_footers_path, notice: "FooterItem deleted successfully."
  end

  private

  def set_footer_item
    @footer_item = FooterItem.find(params[:id])
    @footers = FooterItem.all
  end

  def footer_item_params
    params.require(:footer_item).permit(:label, :icon, :options, :access, :link, :footer_order, :parent_id)
  end
end
