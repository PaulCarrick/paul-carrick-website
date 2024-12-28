# /app/controllers/admin/sections

class Admin::SectionsController < Admin::AbstractAdminController
  def initialize
    super

    @page_limit = 1
    @default_column = 'content_type'
    @has_query = true
    @has_sort = true
    @model_class = Section
  end

  def new
    super

    @content_types = Section.distinct.order(:content_type).pluck(:content_type)
    @images = ImageFile.distinct.order(:name).pluck(:name)
  end

  def create
    begin
      throw "You are not permitted to change #{class_title}." unless @application_user.admin?

      set_item(true, get_params)

      get_item&.description = Utilities.pretty_print_html(get_item&.description) if get_item&.description.present?

      get_item&.save!

      redirect_to admin_sections_path, notice: "Section created successfully."
    rescue => e
      handle_error(:new, e)
    end
  end

  def edit
    super
    get_item&.description = Utilities.pretty_print_html(get_item&.description) if get_item&.description.present?
    @content_types = Section.distinct.order(:content_type).pluck(:content_type)
    @images = ImageFile.distinct.order(:name).pluck(:name)
  end

  def update
    @error_message = nil
    data = get_params
    data[:description] = Utilities.pretty_print_html(data[:description]) if data[:description].present?

    begin
      throw "You are not permitted to change #{class_title}." unless @application_user.admin?

      set_item

      get_record&.update!(get_params)

      redirect_to admin_sections_path, notice: "Section updated successfully."
    rescue => e
      handle_error(:edit, e)
    end
  end
end
