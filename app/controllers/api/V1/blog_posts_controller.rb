module Api
  module V1
    class BlogPostsController < ApplicationController
      def index
        if params[:include_comments]
          render json: BlogPost.all
                               .includes(:post_comments)
                               .as_json(include: :post_comments)
        else
          render json: BlogPost.all
        end
      end

      def show
        if params[:include_comments]
          post = BlogPost.where(id: params[:id]).includes(:post_comments)

          render json: post.includes(:post_comments).as_json(include: :post_comments) if post.present?
        else
          post = BlogPost.find(params[:id])

          render json: post
        end
      end

      def create
        post = BlogPost.new(post_params)
        if post.save
          render json: post, status: :created
        else
          render json: post.errors, status: :unprocessable_entity
        end
      end

      private

      def post_params
        params.require(:blog_post).permit(:title, :author, :posted, :content)
      end
    end
  end
end
