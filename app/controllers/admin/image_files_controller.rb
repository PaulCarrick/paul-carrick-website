# frozen_string_literal: true

# app/controllers/admin/image_files_controller.rb
class Admin::ImageFilesController < ApplicationController
  include Pagy::Backend # Include Pagy for pagination

  before_action :set_image, only: %i[show edit update destroy]

  def index
    if params[:q].present?
      session[:image_files_search] = params[:q]
    elsif session[:image_files_search].present?
      params[:q] = session[:image_files_search]
    else
      session[:image_files_search] = nil
    end

    @q = ImageFile.ransack(params[:q]) # Initialize Ransack search object

    if params[:sort].present?
      session[:image_files_sort] = params[:sort]
    elsif session[:image_files_sort].present?
      params[:sort] = session[:image_files_sort]
    else
      params[:sort] = nil
    end

    if params[:direction].present?
      session[:image_files_sort_direction] = params[:direction]
    elsif session[:image_files_sort_direction].present?
      params[:direction] = session[:image_files_sort_direction]
    else
      params[:direction] = nil
    end

    if params[:q]&.include?("group_cont") && !params[:sort].presence
      sort_column = "slide_order"
      sort_direction = "asc"
    else
      sort_column = ImageFile.column_names.include?(sort_column) ? sort_column : "name"
      sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : "asc"
    end

    # Safeguard against invalid columns and directions
    sort_column = ImageFile.column_names.include?(sort_column) ? sort_column : "name"
    sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : "asc"

    # Combine sorting and Ransack results
    sorted_results = @q.result(distinct: true).order("#{sort_column} #{sort_direction}")

    # Paginate the sorted results
    @pagy, @image_files = pagy(sorted_results, limit: params[:limit] || 3)
  end

  def show
    @image_file = ImageFile.where(id: params[:id])
  end

  def new
    @image_file = ImageFile.new
  end

  def create
    begin
      @image_file = ImageFile.new(image_params)

      @image_file.save!
      redirect_to admin_image_files_path, notice: "Image created successfully."
    rescue => e
      render :new
    end
  end

  def edit
  end

  def update
    if @image_file.update(image_params)
      redirect_to admin_image_files_path, notice: "Image updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @image_file.destroy
    redirect_to admin_image_files_path, notice: "Image deleted successfully."
  end

  private

  def set_image
    @image_file = ImageFile.find(params[:id])
  end

  def image_params
    params.require(:image_file).permit(:name, :group, :slide_order, :mime_type, :caption, :description, :image)
  end
end
