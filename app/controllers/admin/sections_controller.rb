class Admin::SectionsController < ApplicationController
  include Pagy::Backend

  before_action :set_section, only: %i[show edit update destroy]

  def index
    @q = Section.ransack(params[:q]) # Initialize Ransack search object

    # Set default sort column and direction
    sort_column = params[:sort].presence || "content_type"
    sort_direction = params[:direction].presence || "asc"

    # Safeguard against invalid columns and directions
    sort_column = Section.column_names.include?(sort_column) ? sort_column : "content_type"
    sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : "asc"

    # Combine sorting and Ransack results
    sorted_results = @q.result(distinct: true).order("#{sort_column} #{sort_direction}")

    # Paginate the sorted results
    @pagy, @sections = pagy(sorted_results, limit: 1)
  end

  def show
  end

  def new
    @section = Section.new
    @content_types = Section.distinct.pluck(:content_type)
  end

  def create
    @section = Section.new(section_params)

    if @section&.description.present?
      @section&.description = Utilities.pretty_print_html(@section.description)
    end

    if @section&.formatting.present?
      @section&.formatting = Utilities.pretty_print_json(@section.formatting, false)
    end

    if @section.save
      redirect_to admin_sections_path, notice: "Section created successfully."
    else
      render :new
    end
  end

  def edit
    if @section&.description.present?
      @section&.description = Utilities.pretty_print_html(@section.description)
    end

    if @section&.formatting.present?
      @section&.formatting = Utilities.pretty_print_json(@section.formatting, false)
    end

    @content_types = Section.distinct.pluck(:content_type)
  end

  def update
    @error_message = nil
    data = section_params

    if data[:description].present?
      data[:description] = Utilities.pretty_print_html(data[:description])
    end

    if data[:formatting].present?
      data[:formatting] = Utilities.pretty_print_json(data[:formatting], false)
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
                                    :image_file,
                                    :link,
                                    :formatting,
                                    :description)
  end
end
