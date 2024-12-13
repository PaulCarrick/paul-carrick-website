FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "password123" }
    approved { true } # Add additional fields as required by your model
    admin { false }
  end
end

