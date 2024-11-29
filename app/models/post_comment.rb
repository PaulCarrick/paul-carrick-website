class PostComment < ApplicationRecord
  include Checksum
  include Validation

  belongs_to :blog_post

  validates :title, :author, :posted, :content, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[content]
  end

  private

  def content_is_valid
    return unless content.present?

    skip_check = content =~ /^\s*<title>/

    unless skip_check || validate_html(content, :content)
      errors.add(:base, "Invalid HTML in Content.")
    end
  end
end
