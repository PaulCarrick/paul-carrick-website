# app/models/section.rb

class Section < ApplicationRecord
  after_find :verify_checksum
  after_find :setup_formatting

  include Checksum
  include Validation

  validate :at_least_one_field_present
  validate :description_is_valid

  scope :by_content_type, ->(type) { where(content_type: type).order(:section_order) }

  def self.ransackable_attributes(auth_object = nil)
    %w[content_type section_name image link description]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def setup_formatting
    return unless self.formatting.present?

    row_style = self.formatting['row_style']
    self.row_style = row_style.gsub(/\A"|"\z/, '') if row_style.present? && !self.row_style.present?

    return if self.div_ratio.present?

    if ((self.row_style == "text-left") || (self.row_style == "text-right"))
      text_classes = self.formatting['text_classes']
      image_classes = self.formatting['image_classes']
      text_width = Regexp.last_match(1).to_i if text_classes.present? && text_classes =~ /col\-(\d{1,2})/
      image_width = Regexp.last_match(1).to_i if image_classes.present? && image_classes =~ /col\-(\d{1,2})/

      if text_width.present? && (text_width > 0) && image_width.present? && (image_width > 0)
        text_percentage = ((text_width.to_f / 12.0) * 100).floor
        image_percentage = ((image_width.to_f/ 12.0) * 100).floor

        ratios = {
          90 => "90:10",
          80 => "80:20",
          70 => "70:30",
          60 => "60:40",
          50 => "50:50",
          40 => "40:60",
          30 => "30:70",
          20 => "20:80",
          10 => "10:90"
        }

        closest_text_ratio = ratios.keys.min_by { |key| (text_percentage - key).abs }
        closest_image_ratio = ratios.keys.min_by { |key| (image_percentage - key).abs }

        if (closest_text_ratio + closest_image_ratio) === 100
          div_ratio = ratios[closest_text_ratio]
        end
      end
    end

    self.div_ratio = div_ratio
  end

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

  def description_is_valid
    return unless description.present?

    skip_check = description =~ /^\s*<title>/

    unless skip_check || validate_html(description, :description)
      errors.add(:base, "Invalid HTML in Description.")
    end
  end
end
