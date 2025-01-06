# /app/controllers/admin/sections

require 'uri'

class Admin::SectionsController < Admin::AbstractAdminController
  def initialize
    super

    @page_limit     = 1
    @default_column = 'content_type'
    @has_query      = true
    @has_sort       = true
    @model_class    = Section
    @content_types  = []
    @images         = []
    @groups         = []
    @videos         = []
  end

  def new
    super

    setup_options

    @return_url             = params[:return_url].present? ? params[:return_url] : admin_sections_url
    @cancel_url             = params[:cancel_url].present? ? params[:cancel_url] : admin_sections_url
    @read_only_content_type = params[:read_only_content_type].present? ? params[:read_only_content_type] : false
  end

  def create
    begin
      throw "You are not permitted to change #{class_title}." unless @application_user.admin?

      set_item(true, get_params)
      get_item&.description = Utilities.pretty_print_html(get_item&.description) if get_item&.description.present?
      get_item&.save!

      if request.headers['Content-Type'] === "application/json"
        render json: { message: 'Section created successfully', id: get_item.id }, status: :ok
      else
        redirect_to admin_sections_path, notice: "Section created successfully."
      end
    rescue => e
      if request.headers['Content-Type'] === "application/json"
        render json: { error: get_item&.errors&.full_messages }, status: :unprocessable_entity
      else
        handle_error(:new, e)
      end
    end
  end

  def edit
    super

    @return_url             = params[:return_url].present? ? params[:return_url] : admin_section_url(get_item)
    @cancel_url             = URI(params[:cancel_url].present? ? params[:cancel_url] : admin_sections_url)
    @cancel_url.query       = URI.encode_www_form({ canceled: true, section_id: get_item.id })
    @read_only_content_type = params[:read_only_content_type].present? ? params[:read_only_content_type] : false
    @cancel_url             = @cancel_url.to_s
    get_item&.description   = Utilities.pretty_print_html(get_item&.description) if get_item&.description.present?

    setup_options
  end

  def update
    @error_message     = nil
    data               = get_params
    data[:description] = Utilities.pretty_print_html(data[:description]) if data[:description].present?

    begin
      throw "You are not permitted to change #{class_title}." unless @application_user.admin?

      set_item

      get_record&.update!(get_params)

      if request.headers['Content-Type'] === "application/json"
        render json: { message: 'Section updated successfully' }, status: :ok
      else
        redirect_to admin_sections_path, notice: "Section updated successfully."
      end
    rescue => e
      if request.headers['Content-Type'] === "application/json"
        render json: { error: get_record&.errors&.full_messages }, status: :unprocessable_entity
      else
        handle_error(:edit, e)
      end
    end
  end

  def show
    if params[:method] == "delete"
      destroy

      return
    end

    super
  end
  def destroy
    begin
      throw "You are not permitted to change #{class_title}." unless @application_user.admin?

      set_item

      result = get_record&.destroy

      if result.destroyed?
        flash[:notice] = "#{controller_name.singularize.titleize} deleted successfully."

        if params[:return_url].present?
          redirect_to params[:return_url], target: "_self"
        else
          redirect_to action: :index
        end
      else
        raise("Could not delete #{controller_name.singularize.titleize}, ID: #{params[:id]}.")
      end
    rescue => e
      handle_error(:index, e)
    end
  end

  private

  def setup_options
    @content_types = Section.distinct.order(:content_type).pluck(:content_type)
    @images        = ImageFile.where.not(mime_type: "video/mp4").distinct.order(:name).pluck(:name)
    @groups        = ImageFile.distinct.order(:group).pluck(:group)
    @videos        = ImageFile.where(mime_type: "video/mp4").distinct.order(:name).pluck(:name)
  end

  def get_params
    params.require(:section).permit(
      :content_type,
      :section_name,
      :section_order,
      :image,
      :link,
      :description,
      :checksum,
      :row_style,
      :div_ratio,
      image_attributes: {},
      text_attributes:  {},
      formatting:       {}
    )
  end
end
