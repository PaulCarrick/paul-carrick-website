module Api
  module V1
    class PostCommentsController < ApplicationController
      def index
        render json: PostComment.all
      end

      def show
        post_comment = PostComment.find(params[:id])
        render json: post_comment
      end

      def create
        post_comment = PostComment.new(post_comment_params)
        if post_comment.save
          render json: post_comment, status: :created
        else
          render json: post_comment.errors, status: :unprocessable_entity
        end
      end

      private

      def post_comment_params
        params.require(:post_comment).permit(:title, :author, :posted, :content)
      end
    end
  end
end
