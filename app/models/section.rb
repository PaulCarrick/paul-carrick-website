# app/models/section.rb

class Section < ApplicationRecord
  after_find :verify_checksum

  include Checksum
  include Validation

  validate :at_least_one_field_present
  validate :formatting_is_valid
  validate :description_is_valid

  scope :by_content_type, ->(type) { where(content_type: type).order(:section_order) }

  def self.ransackable_attributes(auth_object = nil)
    %w[content_type section_name image link description]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def formatting_to_text
    results = []

    if formatting.present? && formatting_is_valid
      formatting_json = JSON.parse(formatting)

      formatting_json.each do |option|
        results << "#{option[0]}: #{option[1]}"
      end

      results.join("\n")
    end
  end

  def text_to_formatting(text)
    return unless text.present?

    options = text.split("\n")

    return unless options.present?

    results = "{\n"

    options.each do |option|
      option_name, option_value = option.split(":", 2)

      next unless option_name.present? && option_value.present?

      if results != "{\n"
        results << ",\n    \"#{option_name}\": \"#{option_value}\""
      else
        results << "    \"#{option_name}\": \"#{option_value}\""
      end
    end

    results += "\n}"

    self.formatting = results if json_is_valid(results)
  end

  private

  def verify_checksum
    return unless description.present?

    expected_checksum = generate_checksum(description)

    unless checksum == expected_checksum
      Rails.logger.error "Checksum mismatch for record ##{id}"
      raise ActiveRecord::RecordInvalid, "Checksum verification failed for Section record ##{id}"
    end
  end

  def at_least_one_field_present
    return unless image.blank? && link.blank? && description.blank?

    errors.add(:base, "At least one of image, link, or description must be present.")
  end

  def json_is_valid(json)
    return unless json.present?

    begin
      JSON.parse(json)
    rescue => e
      errors.add(:base, "Invalid JSON: #{e.message}\ninput: #{json}.")
    end
  end

  def formatting_is_valid
    json_is_valid(formatting)
  end

  def description_is_valid
    return unless description.present?

    skip_check = description =~ /^\s*<title>/

    unless skip_check || validate_html(description, :description)
      errors.add(:base, "Invalid HTML in Description.")
    end
  end
end
