class Admin::PagesController < ApplicationController
  include Pagy::Backend

  before_action :set_page, only: %i[show edit update destroy]

  def index
    sort_column = params[:sort] || 'title' # Default sorting column
    sort_direction = params[:direction] || 'asc' # Default sorting direction
    @pagy, @pages = pagy(Page.order("#{sort_column} #{sort_direction}"), limit: 30)
  end

  def show
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to admin_pages_path, notice: "Page created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to admin_pages_path, notice: "Page updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to admin_pages_path, notice: "Page deleted successfully."
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:name, :section, :title, :access)
  end
end
