# frozen_string_literal: true

# app/models/section.rb

class Section < ApplicationRecord
  include Checksum
  include Validation

  validate :at_least_one_field_present
  validate :formatting_is_valid
  validate :description_is_valid

  scope :by_content_type, ->(type) { where(content_type: type).order(:section_order) }

  def self.ransackable_attributes(auth_object = nil)
    %w[content_type section_name image link description]
  end

  private

  def at_least_one_field_present
    return unless image.blank? && link.blank? && description.blank?

    errors.add(:base, "At least one of image, link, or description must be present.")
  end

  def formatting_is_valid
    return unless formatting.present?

    begin
      JSON.parse(formatting)
    rescue
      errors.add(:base, "Invalid JSON in formatting.")
    end
  end

  def description_is_valid
    return unless description.present?

    skip_check = description =~ /^\s*<title>/

    unless skip_check || validate_html(description, :description)
      errors.add(:base, "Invalid HTML in Description.")
    end
  end
end
