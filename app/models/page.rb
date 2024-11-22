class Page < ApplicationRecord
  has_many :sections,
           class_name: "Section",
           foreign_key: "content_type", # `content_type` in Section matches...
           primary_key: "section"
  scope :by_page_name, ->(name) {
byebug
    where(name: name)
      .includes(:sections)
      .references(:sections) # Ensure sections are available for ordering
      .order(:section_order) # Explicitly qualify the column with the table name
  }
  validates :name, :section, presence: true
end
