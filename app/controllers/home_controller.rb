# app/controllers/home_controller
# frozen_string_literal: true

include HtmlSanitizer

class HomeController < ApplicationController
  def index
    @contents = Section.where(content_type: "Home").map do |section|
      section.tap do |content|
        content.description = sanitize_html(content.description)
      end
    end
  end
end
