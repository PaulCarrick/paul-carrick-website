class PostComment < ApplicationRecord
  belongs_to :blog_post

  validates :title, :author, :posted, :content, presence: true
end
