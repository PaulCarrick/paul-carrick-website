class ImageFile < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_one_attached :image

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
end
