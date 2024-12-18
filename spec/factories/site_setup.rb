FactoryBot.define do
  factory :site_setup do
    configuration_name { 'default' }
    site_name { 'Test' }
    site_domain { 'example.com' }
    site_host { 'example.com' }
    site_url { 'https://example.com' }
    header_background { '#0d6efd' }
    header_text_color { 'white' }
    footer_background { '#0d6efd' }
    footer_text_color { 'white' }
    container_background { 'white' }
    container_text_color { 'black' }
    page_background_image { "none" }
    facebook_url { 'https://www.facebook.com/test' }
    twitter_url { 'https://x.com/test' }
    instagram_url { 'https://www.instagram.com/test/' }
    linkedin_url { 'https://www.linkedin.com/in/test/' }
    github_url { 'https://github.com/test' }
    owner_name { 'Test User' }
    copyright { 'Copyright © 2024 test.com all rights reserved' }
  end
end
