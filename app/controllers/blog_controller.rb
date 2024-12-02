# app/controllers/blog_controller.rb
# frozen_string_literal: true

include HtmlSanitizer

class BlogController < ApplicationController
  def index
    @blog_type = params[:blog_type].present? ? params[:blog_type] : "Personal"
    @contents = Section.where(content_type: "Blog").map do |section|
      section.tap do |content|
        content.description = sanitize_html(content.description)
      end
    end
  end

  def show
    @blog_type = params[:blog_type].present? ? params[:blog_type] : "Personal"

    if params[:id] == "latest"
      @blog = BlogPost.where(blog_type:@blog_type).order(posted: 'desc').first

      if @blog.present?
        @blog.content = sanitize_html(@blog.content)

        render "latest"

        return
      else
        render nothing: true
      end
    else
      @blog = BlogPost.find(params[:id])
    end
  end
end
