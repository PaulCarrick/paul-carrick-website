FactoryBot.define do
  factory :image_file do
    sequence(:name) { |n| "Test Image - #{n}" }
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

    trait :paul_transparent do
      name { "paul-transparent" }
      caption { "This is Paul Carrick" }
      description { "<p>He is the <b>author</b> of this code.</p>" }
      group { "test-group" }
      slide_order { 1 }

      after(:build) do |image_file|
        image_file.image.attach(
          io:           File.open(Rails.root.join('spec/fixtures/files/paul-transparent.jpg')),
          filename:     'paul-transparent.jpg',
          content_type: 'image/jpeg'
        )
      end
    end

    trait :lori do
      name { "lori" }
      caption { "This is Lori" }
      description { "<p>She is a friend of Paul.</p>" }
      group { "test-group" }
      slide_order { 2 }

      after(:build) do |image_file|
        image_file.image.attach(
          io:           File.open(Rails.root.join('spec/fixtures/files/lori.jpg')),
          filename:     'lori.jpg',
          content_type: 'image/jpeg'
        )
      end
    end

    trait :paul_virginia do
      name { "paul_virginia" }
      caption { "This is Paul and Virginia" }
      description { "<p>Virginia is Paul's wife.</p>" }
      group { "test-group" }
      slide_order { 3 }

      after(:build) do |image_file|
        image_file.image.attach(
          io:           File.open(Rails.root.join('spec/fixtures/files/paulandvirginia.jpg')),
          filename:     'paulandvirginia.jpg',
          content_type: 'image/jpeg'
        )
      end
    end

    trait :backyard do
      name { "backyard" }
      caption { "This is Paul's view" }
      description { "<p>It's from his upper back deck." }
      group { "test-group" }
      slide_order { 4 }

      after(:build) do |image_file|
        image_file.image.attach(
          io:           File.open(Rails.root.join('spec/fixtures/files/WideBackyardPhoto.jpg')),
          filename:     'WideBackyardPhoto.jpg',
          content_type: 'image/jpeg'
        )
      end
    end

    trait :virginia do
      name { "virginia" }
      caption { "This is Virginia" }
      description { "<p>She is Paul's wife. This was taken in King's Canyon Australia." }
      group { "test-group" }
      slide_order { 5 }

      after(:build) do |image_file|
        image_file.image.attach(
          io:           File.open(Rails.root.join('spec/fixtures/files/virginia-kings-canyon.jpg')),
          filename:     "virginia - kings - canyon.jpg ",
          content_type: ' image / jpeg '
        )
      end
    end
  end
end
