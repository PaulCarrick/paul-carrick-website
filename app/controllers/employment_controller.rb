# app/controllers/employment_controller.rb
# frozen_string_literal: true

include HtmlSanitizer

class EmploymentController < ApplicationController
  def index
    @contents = Section.by_content_type("Employment").map do |section|
      section.tap do |content|
        content.description = sanitize_html(content.description)
      end
    end
  end
end
