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
          subsection = nil

          if images =~ /^\s*ImageGroup:\s*(.+)\s*$/
            image_files = ImageFile.where(group: Regexp.last_match(1))

            if image_files.present?
              images = []
              description = ""

              image_files.each do |image_file|
                images << image_file.image_url
                description += "<title>\n#{sanitize_html(image_file.caption)}\n</title>\n<section>\n#{sanitize_html(image_file.description)}\n</section>\n"
              end if image_files.present?

              formatting = add_images_to_formatting(formatting, images)
              images = nil
            else
              byebug if Rails.env === "development" # rubocop:disable Lint/Debugger

              images = @missing_image
            end
          elsif images =~ /^\s*ImageFile:\s*(.+)\s*$/
            image_file = ImageFile.find_by(name: Regexp.last_match(1))

            if image_file&.image_url.present?
              images = image_file.image_url
            else
              byebug if Rails.env === "development" # rubocop:disable Lint/Debugger

              images = @missing_image
            end
          elsif images =~ /^\s*ImageSection:\s*(.+)\s*$/
            image_file = ImageFile.find_by(name: Regexp.last_match(1))

            if image_file&.image_url.present?
              images = image_file.image_url
              description = sanitize_html("<div class='display-4 fw-bold mb-1 text-dark'>#{image_file.caption}</div>")
              subsection = section.dup
              subsection.image = nil
              subsection.link = nil
              formatting_json = JSON.parse(formatting) if formatting.present?
              subsection.formatting = flip_formatting_side(formatting_json)
              subsection.description = image_file.description

              if formatting_json.present? && formatting_json["expanding_rows"].present?
                formatting_json.delete("expanding_rows")
                formatting = formatting_json.to_json
              end
            else
              byebug if Rails.env === "development" # rubocop:disable Lint/Debugger

              images = @missing_image
            end
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
        @contents << subsection if subsection.present?
      end

      @contents.each do |content|
        if content.description =~ /VideoImage:\s*"(.+)"/
          image_file = ImageFile.find_by(name: Regexp.last_match(1))

          if image_file&.image_url.present?
            video_tag = view_context.image_tag(image_file.image_url,
                                               alt: image_file.name,
                                               class: "btn btn-link",
                                               onclick: "showVideoPlayer(this.getAttribute('src'))")
            content.description.gsub!(/VideoImage:\s*"(.+)"/, video_tag)
          end
        end
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

  def flip_formatting_side(formatting_json)
    if formatting_json.present?
      if formatting_json["row_style"].present?
        if formatting_json["row_style"] === "text-left"
          formatting_json["row_style"] = "text-right"
        else
          formatting_json["row_style"] = "text-left"
        end
      elsif formatting_json.present?
        formatting_json["row_style"] = "text-right"
      else
        formatting_json["row_style"] = "text-right"
      end

      if formatting_json["text_classes"].present? && formatting_json["image_classes"].present?
        text_classes = formatting_json["text_classes"]
        image_classes = formatting_json["image_classes"]
        formatting_json["text_classes"] = image_classes
        formatting_json["image_classes"] = text_classes
      end

      if formatting_json["row_classes"].present?
        row_classes = formatting_json["row_classes"]

        row_classes.gsub!(/mt-\d/, '')
        row_classes.gsub!(/pt-\d/, '')

        formatting_json["row_classes"] = row_classes
      end

      formatting_json.to_json
    else
      '{ row_style: "text-right" }'
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
