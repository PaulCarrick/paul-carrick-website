# /app/controllers/admin/pages

class Admin::PagesController < Admin::AbstractAdminController
  def initialize
    super

    @page_limit = 20
    @default_column = 'name'
    @has_query = false
    @has_sort = true
    @model_class = Page
  end
end
