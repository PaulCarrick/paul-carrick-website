# app/controllers/bio_controller.rb
# frozen_string_literal: true

include HtmlSanitizer

class BioController < ApplicationController
  def index
    @contents = Section.where(content_type: "Bio").map do |section|
      section.tap do |content|
        content.description = sanitize_html(content.description)
      end
    end
  end
end
