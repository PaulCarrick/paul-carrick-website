class PostComment < ApplicationRecord
  after_find :verify_checksum

  include Checksum
  include Validation

  belongs_to :blog_post

  validates :title, :author, :posted, :content, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[content]
  end

  private

  def verify_checksum
    expected_checksum = generate_checksum(content)
    unless checksum == expected_checksum
      Rails.logger.error "Checksum mismatch for record ##{id}"
      raise ActiveRecord::RecordInvalid, "Checksum verification failed for PostComment record ##{id}"
    end
  end

  def content_is_valid
    return unless content.present?

    skip_check = content =~ /^\s*<title>/

    unless skip_check || validate_html(content, :content)
      errors.add(:base, "Invalid HTML in Content.")
    end
  end
end
