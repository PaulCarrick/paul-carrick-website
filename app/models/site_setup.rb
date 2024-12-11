# /app/models/contacts.rb
class SiteSetup < ActiveRecord::Base
  validates :configuration_name, :site_name, :site_domain, :site_host, :site_url,  presence: true
end
