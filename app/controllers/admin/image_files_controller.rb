# frozen_string_literal: true

# app/controllers/admin/image_files_controller.rb
class Admin::ImageFilesController < ApplicationController
  include Pagy::Backend # Include Pagy for pagination

  before_action :set_image, only: %i[show edit update destroy]

  def index
    @q = ImageFile.ransack(params[:q]) # Initialize Ransack search object

    # Set default sort column and direction
    sort_column = params[:sort].presence || "name"
    sort_direction = params[:direction].presence || "asc"

    # Safeguard against invalid columns and directions
    sort_column = ImageFile.column_names.include?(sort_column) ? sort_column : "name"
    sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : "asc"

    # Combine sorting and Ransack results
    sorted_results = @q.result(distinct: true).order("#{sort_column} #{sort_direction}")

    # Paginate the sorted results
    @pagy, @image_files = pagy(sorted_results, limit: params[:limit] || 4)
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
      byebug
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
    params.require(:image_file).permit(:name, :mime_type, :caption, :description, :image)
  end
end
