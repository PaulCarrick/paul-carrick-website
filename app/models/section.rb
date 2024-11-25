# frozen_string_literal: true

# app/models/section.rb

class Section < ApplicationRecord
  validate :at_least_one_field_present
  scope :by_content_type, ->(type) { where(content_type: type).order(:section_order) }

  def self.ransackable_attributes(auth_object = nil)
    %w[description]
  end

  private

  def at_least_one_field_present
    return unless image.blank? && link.blank? && description.blank?

    errors.add(:base, "At least one of image, link, or description must be present.")
  end
end
