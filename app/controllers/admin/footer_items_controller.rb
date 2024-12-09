# /app/controllers/admin/footer_items

class Admin::FooterItemsController < Admin::AbstractAdminController
  def initialize
    super

    @page_limit = 20
    @default_column = 'label'
    @has_query = false
    @has_sort = true
    @sort_column = nil
    @sort_direction = nil
    @results = nil
    @model_class = FooterItem
  end

  private

  def get_params
    parameters = {}

    if params[:q].present? # Searching via ransack
      parameters[:q] = params.require(:q).permit(:label_cont,
                                                 :icon_cont,
                                                 :options_cont,
                                                 :link_cont,
                                                 :access_cont,
                                                 :footer_order_cont,
                                                 :parent_id_cont)
    else # Item
      if params[:footer_item].present?
        parameters = params.require(:footer_item).permit(:label,
                                                         :icon,
                                                         :options,
                                                         :link,
                                                         :access,
                                                         :footer_order,
                                                         :parent_id)
      else # Get
        parameters = params.permit(:sort,
                                   :direction,
                                   :clear_sort,
                                   :clear_search)
      end
    end

    parameters
  end
end
