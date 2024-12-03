class AddSectionToImageCollections < ActiveRecord::Migration[8.0]
  def change
    add_column :image_collections, :content_type, :string
    add_column :image_collections, :section_name, :string
    add_column :image_collections, :section_order, :integer
  end
end
