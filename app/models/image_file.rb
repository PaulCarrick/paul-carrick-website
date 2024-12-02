class ImageFile < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_one_attached :image
  has_and_belongs_to_many :image_collections

  def self.ransackable_attributes(auth_object = nil)
    %w[ name caption description ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ image_attachment image_blob image_collections ]
  end

  def image_url
    Rails.application.routes.url_helpers.url_for(self.image) if self.image.attached?
  end

  def as_json(options = {})
    super(options).merge({ image_url: image_url })
  end
end
