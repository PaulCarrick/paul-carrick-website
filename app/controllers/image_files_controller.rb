# frozen_string_literal: true

# app/controllers/image_files_controller.rb
class ImageFilesController < ApplicationController
  def show
    if params[:id] == "picture-of-the-day"
      image_files = ImageFile.jpegs_with_captions_in_an_image_group
      random_number = rand(image_files.length)
      @image_file = image_files[random_number]

      render "picture_of_the_day"

      return
    else
      set_image
    end
  end

  private

  def set_image
    @image_file = ImageFile.find(params[:id])
  end

  def image_params
    params.require(:image_file).permit(:name, :group, :slide_order, :mime_type, :caption, :description, :image)
  end
end