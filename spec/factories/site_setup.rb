FactoryBot.define do
  factory :site_setup do
    configuration_name { 'default' }
    site_name { 'Test' }
    site_domain { 'test.com' }
    site_host { 'test.com' }
    site_url {  'https://test.com' }
    facebook_url { 'https://www.facebook.com/test' }
    twitter_url { 'https://x.com/test' }
    instagram_url { 'https://www.instagram.com/test/' }
    linkedin_url { 'https://www.linkedin.com/in/test/' }
    github_url { 'https://github.com/test' }
    owner_name { 'Test User' }
    copyright { 'Copyright © 2024 test.com all rights reserved' }
  end
end
