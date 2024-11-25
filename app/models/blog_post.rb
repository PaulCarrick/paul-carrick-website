class BlogPost < ApplicationRecord
  has_many :post_comments, dependent: :destroy

  validates :title, :author, :posted, :content, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[content]
  end
end
