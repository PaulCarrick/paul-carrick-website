FactoryBot.define do
  factory :image_file do
    name { "test" }
    caption { "Test Image" }
    description { "This is a test image." }
    mime_type { "image/jpeg" }
    group { "test" }
    slide_order { 1 }

    after(:build) do |image_file|
      image_file.image.attach(
        io:           File.open(Rails.root.join('spec/fixtures/files/sample.jpg')),
        filename:     'test.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
end
