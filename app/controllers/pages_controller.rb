#frozen_string_literal: true

# app/controllers/pages_controller.rb

include HtmlSanitizer

class PagesController < ApplicationController
  def show
    load_page
  end

  private

  def load_page
    page = Page.find_by(name: params[:id])

    if page.present?
      @contents = Section.by_content_type(page.section)

      if params[:section_name].present?
        # Focus on the specific section if `section_name` is provided
        @focused_section = @contents.find { |section| section.section_name == params[:section_name] }
      end

      @contents.each do |section|
        section.tap do |content|
          content.description = sanitize_html(content.description)
        end
      end
    else
      redirect_to root_path, alert: "Can't find page for: #{params[:id]}."
    end
  end
end
