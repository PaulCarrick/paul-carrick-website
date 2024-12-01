class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  def admin?
    admin
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[ email name ]
  end
end
