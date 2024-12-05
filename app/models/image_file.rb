class ImageFile < ApplicationRecord
  after_find :verify_checksum

  include Rails.application.routes.url_helpers
  include Checksum
  include Validation

  has_one_attached :image

  validates :name, :image, presence: true
  validate :description_is_valid

  def self.ransackable_attributes(auth_object = nil)
    %w[ name group caption description ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ image_attachment image_blob ]
  end

  def image_url
    Rails.application.routes.url_helpers.url_for(self.image) if self.image.attached?
  end

  def as_json(options = {})
    super(options).merge({ image_url: image_url })
  end

  private

  def verify_checksum
    expected_checksum = generate_checksum(description)
    unless checksum == expected_checksum
      Rails.logger.error "Checksum mismatch for record ##{id}"
      raise ActiveRecord::RecordInvalid, "Checksum verification failed for Image File record ##{id}"
    end
  end

  def description_is_valid
    return unless description.present?

    unless validate_html(description, :description)
      errors.add(:base, "Invalid HTML in Description.")
    end
  end
end
