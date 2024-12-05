# frozen_string_literal: true

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
      @missing_image ||= view_context.image_path("missing-image.jpg")
      @contents = []
      sections = Section.by_content_type(page.section)

      if params[:section_name].present?
        @focused_section = sections.find { |section| section.section_name == params[:section_name] }
      end

      sections.each do |section|
        if section.image.present?
          images = section.image.dup
          description = sanitize_html(section.description)
          formatting = section.formatting

          if images =~ /^\s*ImageGroup:\s*(.+)\s*$/
            image_files = ImageFile.where(group: Regexp.last_match(1))
            images = []
            description = ""

            image_files.each do |image_file|
              images << image_file.image_url
              description += "<title>\n#{sanitize_html(image_file.caption)}\n</title>\n<section>\n#{sanitize_html(image_file.description)}\n</section>\n"
            end if image_files.present?

            formatting = add_images_to_formatting(formatting, images)
            images = nil
          elsif images =~ /^\s*\[\s*(.+?)\s*\]\s*$/m
            image_files = Regexp.last_match(1).split(",")
            images = []

            image_files.each do |image_file|
              images << get_image_path(image_file)
            end if image_files.present?

            formatting = add_images_to_formatting(formatting, images)
            images = nil
          else
            images = get_image_path(images)
          end

          section.image = images
          section.description = description
          section.formatting = formatting
        end

        @contents << section
      end
    else
      redirect_to root_path, alert: "Can't find page for: #{params[:id]}."
    end
  end

  def get_image_path(image_url)
    begin
      image_url.strip!

      if image_url =~ /^\s*http/i
        image_url
      else
        view_context.image_path(image_url)
      end
    rescue
      byebug if Rails.env === "development" # rubocop:disable Lint/Debugger

      @missing_image
    end
  end

  def add_images_to_formatting(formatting, images)
    if formatting.present?
      json = JSON.parse(formatting)
      json["slide_show_images"] = images
      json.to_json
    else
      { slide_show_images: images }.to_json
    end
  end
end
