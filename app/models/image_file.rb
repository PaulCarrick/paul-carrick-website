class ImageFile < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_one_attached :image
  attr_accessor :image_url

  def image_url
    Rails.application.routes.url_helpers.url_for(self.image) if self.image.attached?
  end

  def as_json(options = {})
    super(options).merge({ image_url: image_url })
  end
end
