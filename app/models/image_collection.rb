class ImageCollection < ApplicationRecord
  has_and_belongs_to_many :image_files

  def self.ransackable_attributes(auth_object = nil)
    %w[ name content_type section_name section_order ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ image_files ]
  end
end
