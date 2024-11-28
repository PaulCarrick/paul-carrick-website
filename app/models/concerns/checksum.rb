module Checksum
  require 'openssl'

  extend ActiveSupport::Concern

  included do
    before_save :populate_checksum
    before_update :populate_checksum
  end

  private

  def populate_checksum
    if @section&.description.present?
      @section.checksum = generate_checksum(@section.description)
    end
  end

  # Generate a 2048-bit checksum
  def generate_checksum(data)
    # SHA-512 produces a 512-bit (64-byte) hash
    digest = OpenSSL::Digest::SHA512.new

    # Create a 2048-bit checksum by hashing iteratively
    checksum = ""
    4.times do
      checksum += digest.digest(data).unpack1("H*") # Convert to hex
      data = digest.digest(data) # Hash again for different output
    end

    checksum
  end
end
