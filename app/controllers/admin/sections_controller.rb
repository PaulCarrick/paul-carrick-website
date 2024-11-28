class Admin::SectionsController < ApplicationController
  require "htmlbeautifier"

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

    if @section&.formatting.present?
      @section.formatting = JSON.pretty_generate(JSON.parse(@section.formatting)).gsub(/^(\s+)/) { |match| "    " * (match.size / 2) }
    end

    if @section&.description.present?
      @section.description = HtmlBeautifier.beautify(@section.description)
    end

    if @section.save
      redirect_to admin_sections_path, notice: "Section created successfully."
    else
      render :new
    end
  end

  def edit
    if @section.description.present?
      @section.description = HtmlBeautifier.beautify(@section.description)
    end

    if @section.formatting.present?
      @section.formatting = JSON.pretty_generate(JSON.parse(@section.formatting)).gsub(/^(\s+)/) { |match| "    " * (match.size / 2) }
    end

    @content_types = Section.distinct.pluck(:content_type)
  end

  def update
    @error_message = nil
    data = section_params

    if data[:formatting].present?
      data[:formatting] = JSON.pretty_generate(JSON.parse(data[:formatting])).gsub(/^(\s+)/) { |match| "    " * (match.size / 2) }
    end

    if data[:description].present?
      data[:description] = HtmlBeautifier.beautify(data[:description])
    end

    begin
      @section.update!(data)
      redirect_to admin_sections_path, notice: "Section updated successfully."
    rescue => e
      @content_types = Section.distinct.pluck(:content_type)
      @error_message = @section.errors.full_messages.join(", ")
      @error_message = e.message unless @error_message.present?
      @error_message = "There was an error updating the section: #{@error_message}"
      flash[:error] = @error_message
      render :edit, turbo: false
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
