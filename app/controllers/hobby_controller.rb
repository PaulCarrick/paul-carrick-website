# app/controllers/hobby_controller.rb
# frozen_string_literal: true

include HtmlSanitizer

class HobbyController < ApplicationController
  def index
    @contents = Section.by_content_type("Hobby").map do |section|
      section.tap do |content|
        content.description = sanitize_html(content.description)
      end
    end
  end
end
