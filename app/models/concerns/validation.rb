module Validation
  require 'nokogiri'

  extend ActiveSupport::Concern

  private

  def validate_html(html_string)
    begin
      # Parse the HTML
      Nokogiri::HTML::Document.parse(html_string) do |config|
        config.strict # Enables strict parsing for validation
      end
      true # HTML is valid
    rescue Nokogiri::XML::SyntaxError => e
      errors.add(:description, e.message)
      Rails.logger.error("*** HTML Validation Error: #{e.message} ***")
      false # HTML is invalid
    end
  end

  def validate_checksum(checksum, data)
    return true unless data.present?

    checksum == generate_checksum(data)
  end
end
