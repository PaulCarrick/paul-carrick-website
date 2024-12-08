class Admin::PagesController < ApplicationController
  include Pagy::Backend

  before_action :set_page, only: %i[show edit update destroy]

  def index
    if params[:sort].present?
      session[:pages_sort] = params[:sort]
    elsif session[:pages_sort].present?
      params[:sort] = session[:pages_sort]
    else
      params[:sort] = nil
    end

    if params[:direction].present?
      session[:pages_sort_direction] = params[:direction]
    elsif session[:pages_sort_direction].present?
      params[:direction] = session[:pages_sort_direction]
    else
      params[:direction] = nil
    end

    # Set default sort column and direction
    sort_column = params[:sort].presence || "title"
    sort_direction = params[:direction].presence || "asc"

    # Safeguard against invalid columns and directions
    sort_column = Page.column_names.include?(sort_column) ? sort_column : "title"
    sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : "asc"

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
