# /app/controllers/admin/pages

class Admin::PagesController < Admin::AbstractAdminController
  def initialize
    super

    @page_limit             = 20
    @default_column         = 'name'
    @has_query              = false
    @has_sort               = true
    @model_class            = Page
    @read_only_content_type = true
  end

  def edit
    if (params[:canceled] == "true") && params[:section_id].present?
      Section.delete(params[:section_id])
    end

    super
  end

  def add_section_to_page
    page = set_item

    if page&.id.present?
      page.save!
    else
      page.create!(get_params)
    end

    unless page&.section.present?
      @error_message = "You cannot add a section until Section is set."
      flash[:error]  = @error_message

      redirect_to action: new

      return
    end

    section_order = page&.sections&.maximum(:section_order).to_i + 1
    section_order = 1 unless section_order.present?
    section       = Section.create!(content_type: page&.section, description: "New Section. Please replace this text.", section_order: section_order)

    redirect_to edit_admin_section_path(section,
                                        read_only_content_type: true,
                                        return_url:             edit_admin_page_path(page),
                                        cancel_url:             edit_admin_page_path(page))
  end

  private

  def set_item(create = false, create_params = {})
    if create
      @result = @model_class.new(create_params)
    else
      if params[:id] =~ /\d+/
        result  = @model_class.find(params[:id])
        results = Page.by_page_name(result.name)
        @result = results.present? ? results.first : result
      else
        results = Page.by_page_name(params[:id])
        @result = results.first if results.present?
      end
    end

    instance_variable_set(get_singular_record_name, @result)
  end
end
