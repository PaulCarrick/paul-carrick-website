# frozen_string_literal: true

# app/controllers/admin/image_collections_controller.rb
class Admin::ImageCollectionsController < ApplicationController
  include Pagy::Backend # Include Pagy for pagination

  before_action :set_collection, only: %i[show edit update destroy]

  def index
    @q = ImageCollection.ransack(params[:q]) # Initialize Ransack search object

    # Set default sort column and direction
    sort_column = params[:sort].presence || "name"
    sort_direction = params[:direction].presence || "asc"

    # Safeguard against invalid columns and directions
    sort_column = ImageCollection.column_names.include?(sort_column) ? sort_column : "name"
    sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : "asc"

    # Combine sorting and Ransack results
    sorted_results = @q.result(distinct: true).order("#{sort_column} #{sort_direction}")

    # Paginate the sorted results
    @pagy, @image_collections = pagy(sorted_results, limit: params[:limit] || 4)
  end

  def show
    @image_collection = ImageCollection.where(id: params[:id])
  end

  def new
    @image_collection = ImageCollection.new
  end

  def create
    begin
      @image_collection = ImageCollection.new(collection_params)

      @image_collection.save!
      redirect_to admin_image_collections_path, notice: "Image Collection created successfully."
    rescue => e
      byebug
      render :new
    end
  end

  def edit
  end

  def update
    if @image_collection.update(collection_params)
      redirect_to admin_image_collections_path, notice: "Image Collection updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @image_collection.destroy
    redirect_to admin_image_collections_path, notice: "Image Collection deleted successfully."
  end

  private

  def set_collection
    @image_collection = ImageCollection.find(params[:id])
  end

  def collection_params
    params.require(:image_collection).permit(:name, :content_type, :section_name, :section_order)
  end
end
