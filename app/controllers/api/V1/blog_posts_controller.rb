module Api
  module V1
    class BlogPostsController < ApplicationController
      include Pagy::Backend # Include Pagy for pagination

      before_action :set_blog, only: %i[show update destroy]

      def index
        @q = BlogPost.ransack(params[:q])
        @results = @q.result(distinct: true).includes(:post_comments).order(posted: :desc)
        @pagy, @blog_posts = pagy(@results, limit: params[:limit] || 3)

        # Add pagination details to headers before rendering
        pagy_headers_merge(@pagy)

        # Render the JSON response
        if params[:include_comments]
          render json: {
            meta: pagy_metadata(@pagy),
            blog_posts: @blog_posts.as_json(include: :post_comments)
          }
        else
          render json: {
            meta: pagy_metadata(@pagy),
            blog_posts: @blog_posts
          }
        end
      end

      def show
        return unless @blog.present?

        if params[:include_comments]
          render json: @blog.as_json(include: :post_comments)
        else
          render json: @blog
        end
      end

      def create
        begin
          blog = BlogPost.new(blog_params)

          blog.save!

          render json: blog, status: :created
        rescue => e
          render json: e.message, status: :unprocessable_entity
        end
      end

      def update
        return unless @blog.present?

        begin
          @blog.update!(blog_params)

          render json: { error: "" }, status: :ok
        rescue => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

      def destroy
        return unless @blog.present?

        begin
          @blog.destroy!

          render json: { error: "" }, status: :ok
        rescue => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

      private

      def set_blog
        @blog = nil

        return unless params[:id].present?

        begin
          @blog = BlogPost.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Blog post: #{params[:id]} not found" }, status: :not_found
        end
      end

      def blog_params
        params.require(:blog_post).permit(:title, :author, :posted, :content)
      end
    end
  end
end
