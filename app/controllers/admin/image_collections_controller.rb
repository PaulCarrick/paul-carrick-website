# frozen_string_literal: true

# app/controllers/admin/image_collections_controller.rb
class Admin::ImageCollectionsController < ApplicationController
  include Pagy::Backend # Include Pagy for pagination

  before_action :set_collection, only: %i[show update destroy]

  def index
    image_collections = ImageCollection.all.includes(:image_files)

    @pagy, @image_collections = pagy(image_collections, limit: params[:limit] || 10)

    # Add pagination details to headers before rendering
    pagy_headers_merge(@pagy)
  end

  def show
    @image_collection = ImageCollection.where(id: params[:id])
  end

  def create
    image_collection = ImageCollection.new(image_collection_params)

    image_collection.save!
  end
end

def update
  return unless @image_collection.present?

  @image_collection.update!(image_collection_params)
end

def destroy
  return unless @image_collection.present?

  begin
    @image_collection.destroy!

    render json: { error: "" }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end

private

def set_collection
  @image_collection = nil

  return unless params[:id].present?

  begin
    @image_collection = ImageCollection.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "ImageFile Collection: #{params[:id]} not found" }, status: :not_found
  end
end

def image_collection_params
  params.require(:image_collection).permit(:name)
end
