class Admin::SectionsController < ApplicationController
  include Pagy::Backend

  before_action :set_section, only: %i[show edit update destroy]

  def index
    sort_column = params[:sort] || "content_type" # Default sorting column
    sort_direction = params[:direction] || "asc" # Default sorting direction
    @pagy, @sections = pagy(Section.order("#{sort_column} #{sort_direction}"), limit: 3)
  end

  def show
  end

  def new
    @section = Section.new
    @content_types = Section.distinct.pluck(:content_type)
  end

  def create
    @section = Section.new(section_params)

    if @section.save
      redirect_to admin_sections_path, notice: "Section created successfully."
    else
      render :new
    end
  end

  def edit
    if @section.formatting/present?
      @section.formatting = JSON.pretty_generate(JSON.parse(@section.formatting)).gsub(/^(\s+)/) { |match| "    " * (match.size / 2) }
    end

    @content_types = Section.distinct.pluck(:content_type)
  end

  def update
    if @section.update(section_params)
      redirect_to admin_sections_path, notice: "Section updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @section.destroy
    redirect_to admin_sections_path, notice: "Section deleted successfully."
  end

  private

  def set_section
    @section = Section.find(params[:id])
  end

  def section_params
    params.require(:section).permit(:content_type,
                                    :section_name,
                                    :section_order,
                                    :image,
                                    :link,
                                    :formatting,
                                    :description)
  end
end
