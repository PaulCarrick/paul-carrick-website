# /app/controllers/admin/pages

class Admin::PagesController < Admin::AbstractAdminController
  def initialize
    super

    @page_limit = 20
    @default_column = 'name'
    @has_query = false
    @has_sort = true
    @sort_column = nil
    @sort_direction = nil
    @results = nil
    @model_class = Page
  end

  private

  def get_params
    parameters = {}

    if params[:q].present? # Searching via ransack
      parameters[:q] = params.require(:q).permit(:name_cont,
                                                 :section_cont,
                                                 :title_cont,
                                                 :access_cont)
    else
      # Item
      if params[:menu_item].present?
        parameters = params.require(:menu_item).permit(:name,
                                                       :title,
                                                       :section,
                                                       :access)
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
