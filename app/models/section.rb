# frozen_string_literal: true

class Section < ApplicationRecord
  validate :at_least_one_field_present
  scope :by_content_type, ->(type) { where(content_type: type).order(:section_order) }

  searchkick

  private

  def at_least_one_field_present
    return unless image.blank? && link.blank? && description.blank?

    errors.add(:base, "At least one of image, link, or description must be present.")
  end
end
