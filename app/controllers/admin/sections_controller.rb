# /app/controllers/admin/sections

class Admin::SectionsController < Admin::AbstractAdminController
  def initialize
    super

    @page_limit = 1
    @default_column = 'content_type'
    @has_query = true
    @has_sort = true
    @sort_column = nil
    @sort_direction = nil
    @results = nil
    @model_class = Section
  end

  def new
    super

    @content_types = Section.distinct.pluck(:content_type)
  end

  def create
    begin
      section = @model_class.new(get_params)
      section.description = Utilities.pretty_print_html(section.description) if section.description.present?
      section.formatting = Utilities.pretty_print_json(section.formatting, false) if section.formatting.present?

      section.save!

      redirect_to admin_sections_path, notice: "Section created successfully."
    rescue => e
      render :new, notice: "Cannot save section (#{e.message}) please correct errors and resubmit"
    end
  end

  def edit
    super

    @model_name.description = Utilities.pretty_print_html(@model_name.description) if @model_name.description.present?
    @model_name.formatting = Utilities.pretty_print_json(@model_name.formatting, false) if @model_name.formatting.present?
    @content_types = Section.distinct.pluck(:content_type)
  end

  def update
    @error_message = nil
    data = get_params
    data[:description] = Utilities.pretty_print_html(data[:description]) if data[:description].present?
    data[:formatting] = Utilities.pretty_print_json(data[:formatting], false) if data[:formatting].present?

    begin
      @model_name.update!(data)

      redirect_to admin_sections_path, notice: "Section updated successfully."
    rescue => e
      @content_types =  @model_name.distinct.pluck(:content_type)
      @error_message = @model_name.errors.full_messages.join(", ")
      @error_message = e.message unless @error_message.present?
      @error_message = "There was an error updating the section: #{@error_message}"
      flash[:error] = @error_message

      render :edit, turbo: false
    end
  end

  private

  def get_params
    parameters = {}

    if params[:q].present? # Searching via ransack
      parameters[:q] = params.require(:q).permit(:content_type_cont,
                                                 :section_name_cont,
                                                 :title_cont,
                                                 :section_order_cont,
                                                 :image_cont,
                                                 :link_cont,
                                                 :formatting_cont,
                                                 :description_cont)
    else
      # Item
      if params[:menu_item].present?
        parameters = params.require(:menu_item).permit(:content_type,
                                                       :section_name,
                                                       :title,
                                                       :section_order,
                                                       :image,
                                                       :link,
                                                       :formatting,
                                                       :description,
                                                       :checksum)
      else
        # Get
        parameters = params.permit(:sort,
                                   :direction,
                                   :clear_sort,
                                   :clear_search)
      end
    end

    parameters
  end
end
