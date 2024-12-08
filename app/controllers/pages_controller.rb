# frozen_string_literal: true

# app/controllers/pages_controller.rb

include HtmlSanitizer

class PagesController < ApplicationController
  def show
    load_page
  end

  private

  def load_page
    @page = Page.find_by(name: params[:id])

    if @page.present?
      setup_defaults

      @contents = build_contents

      process_video_images
    else
      redirect_to root_path, alert: "Can't find page for: #{params[:id]}."
    end
  end

  def setup_defaults
    @missing_image ||= view_context.image_path("missing-image.jpg")
  end

  def build_contents
    contents = []
    sections = Section.by_content_type(@page.section)

    set_focused_section(sections)

    sections.each do |section|
      subsection = process_section(section)
      contents << section
      contents << subsection if subsection.present?
    end

    contents
  end

  def set_focused_section(sections)
    return unless params[:section_name].present?

    @focused_section = sections.find { |section| section.section_name == params[:section_name] }
  end

  def process_section(section)
    return unless section.image.present?

    images, description, formatting, subsection = process_image(section)
    section.image = images
    section.description = description
    section.formatting = formatting

    subsection
  end

  def process_image(section)
    images = section.image.dup.strip
    description = sanitize_html(section.description)
    formatting = section.formatting
    subsection = nil

    case images
    when /^\s*ImageGroup:\s*(.+)\s*$/
      images, description, formatting = handle_image_group(Regexp.last_match(1), formatting)
    when /^\s*ImageFile:\s*(.+)\s*$/
      images = handle_single_image_file(Regexp.last_match(1))
    when /^\s*ImageSection:\s*(.+)\s*$/
      images, description, subsection, formatting = handle_image_section(section, Regexp.last_match(1), formatting)
    when /^\s*\[\s*(.+?)\s*\]\s*$/m
      images, formatting = handle_image_array(Regexp.last_match(1), formatting)
    else
      images = get_image_path(images)
    end

    [ images, description, formatting, subsection ]
  end

  def handle_image_group(group_name, formatting)
    image_files = ImageFile.by_image_group(group_name)

    if image_files.present?
      images = image_files.map(&:image_url)
      description = image_files.map do |image_file|
        "<title>\n#{sanitize_html(image_file.caption)}\n</title>\n<section>\n#{sanitize_html(image_file.description)}\n</section>\n"
      end.join
      formatting = add_images_to_formatting(formatting, images)
      [ nil, description, formatting ]
    else
      [ @missing_image, "", formatting ]
    end
  end

  def handle_single_image_file(file_name)
    image_file = ImageFile.find_by(name: file_name)
    image_file&.image_url || @missing_image
  end

  def handle_image_section(section, file_name, formatting)
    image_file = ImageFile.find_by(name: file_name)

    if image_file&.image_url.present?
      description = sanitize_html("<div class='display-4 fw-bold mb-1 text-dark'>#{image_file.caption}</div>")
      subsection, formatting = build_subsection(section, image_file, formatting)

      [ image_file.image_url, description, subsection, formatting ]
    else
      [ @missing_image, "", nil, nil ]
    end
  end

  def build_subsection(section, image_file, formatting)
    subsection = section.deep_dup
    subsection.link = nil
    subsection.image = nil
    subsection.formatting = flip_formatting_side(formatting)
    subsection.description = image_file.description

    if formatting.include?('expanding_rows')
      json = JSON.parse(formatting)

      json.delete("expanding_rows")

      formatting = json.to_json
    end

    [ subsection, formatting ]
  end

  def handle_image_array(image_list, formatting)
    images = image_list.split(",").map { |image_file| get_image_path(image_file) }
    [ nil, add_images_to_formatting(formatting, images) ]
  end

  def process_video_images
    @contents.each do |content|
      next unless content.description =~ /VideoImage:\s*"(.+)"/

      replace_video_image_tag(content, Regexp.last_match(1))
    end
  end

  def replace_video_image_tag(content, file_name)
    image_file = ImageFile.find_by(name: file_name)

    if image_file&.image_url.present?
      video_tag = view_context.image_tag(
        image_file.image_url,
        alt: image_file.name,
        class: "btn btn-link",
        onclick: "showVideoPlayer(this.getAttribute('src'))"
      )
      content.description.gsub!(/VideoImage:\s*"(.+)"/, video_tag)
    end
  end

  def get_image_path(image_url)
    image_url.strip!

    if image_url =~ /^\s*http/i
      image_url
    else
      view_context.image_path(image_url)
    end
  rescue
    @missing_image
  end

  def flip_formatting_side(formatting)
    return '{ row_style: "text-right" }' unless formatting.present?

    formatting_json = JSON.parse(formatting)

    formatting_json["row_style"] =
      case formatting_json["row_style"]
      when "text-left" then "text-right"
      else "text-left"
      end

    swap_classes!(formatting_json)

    formatting_json.to_json
  end

  def swap_classes!(formatting_json)
    if formatting_json["text_classes"].present? && formatting_json["image_classes"].present?
      formatting_json["image_classes"].gsub!(/w-\d\d|w-\d\d\d/, "")
      formatting_json["text_classes"], formatting_json["image_classes"] =
        formatting_json["image_classes"], formatting_json["text_classes"]
    end

    if formatting_json["row_classes"].present?
      formatting_json["row_classes"].gsub!(/mt-\d|pt-\d/, "")
    end
  end

  def add_images_to_formatting(formatting, images)
    json = formatting.present? ? JSON.parse(formatting) : {}
    json["slide_show_images"] = images
    json.to_json
  end
end
