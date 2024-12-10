# /app/controllers/admin/blog_posts

class Admin::BlogPostsController < Admin::AbstractAdminController
  def initialize
    super

    @page_limit = 3
    @default_column = 'title'
    @has_query = true
    @has_sort = true
    @model_class = BlogPost
  end
end
