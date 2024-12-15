class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :password, presence: true, on: :create
  validates :password, confirmation: true, allow_blank: true

  # Skip password validation if the password is blank during update
  def password_required?
    new_record? || password.present?
  end

  def admin?
    admin
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[email name]
  end
end
