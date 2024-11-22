class BlogPost < ApplicationRecord
  has_many :post_comments, dependent: :destroy

  validates :title, :author, :posted, :content, presence: true

  searchkick
end
