class CreateSiteSetup < ActiveRecord::Migration[8.0]
  def change
    create_table :site_setups do |t|
      t.string :configuration_name, null: false
      t.string :site_name, null: false
      t.string :site_domain, null: false
      t.string :site_host, null: false
      t.string :site_url, null: false
      t.string :facebook_url
      t.string :twitter_url
      t.string :instagram_url
      t.string :linkedin_url
      t.string :github_url
      t.string :owner_name
      t.string :copyright

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }, null: false
    end
  end
end
