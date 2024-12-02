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
end
