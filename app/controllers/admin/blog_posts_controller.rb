# /app/controllers/admin/blog_posts

class Admin::BlogPostsController < Admin::AbstractAdminController
  def initialize
    super

    @page_limit = 3
    @default_column = 'title'
    @has_query = true
    @has_sort = true
    @sort_column = nil
    @sort_direction = nil
    @results = nil
    @model_class = BlogPost
  end

  private

  def get_params
    parameters = {}

    if params[:q].present? # Searching via ransack
      parameters[:q] = params.require(:q).permit(:author_cont,
                                                 :title_cont,
                                                 :content_cont,
                                                 :posted_cont)
    else # Post
      if params[:blog_post].present?
        parameters = params.require(:blog_post).permit(:author,
                                                       :title,
                                                       :content,
                                                       :posted,
                                                       :checksum)
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
