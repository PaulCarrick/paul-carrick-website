# frozen_string_literal: true
# app/controllers/pages_controller.rb

class PagesController < ApplicationController
  before_action :validate_page_name

  PAGES = {
    bio: "Bio",
    blog: "Blog",
    employment: "Employment",
    family: "Family",
    hobby: "Hobby",
    home: "Home",
    live: "Live",
    overview: "Overview",
    portfolio: "Portfolio"
  }.freeze

  def show
    @contents = Section.by_content_type(@page_name).map do |section|
      section.tap do |content|
        content.description = sanitize_html(content.description)
      end
    end
  end

  private

  def validate_page_name
    @page_name = PAGES[params[:id].to_sym]

    unless @page_name.present?
      redirect_to root_path, alert: 'Invalid page type'
    end
  end
end
