FactoryBot.define do
  factory :section do
    content_type { "Test" }
    section_name { "Test" }
    section_order { 1 }
    image { "ImageFile:test" }
    link { "/images/test.jpg" }
    formatting { '{ "row_style": "text-left" }' }
    description { "This is a test." }
  end
end
