class CreateImageCollectionsImageFilesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :image_collections_files do |t|
      t.references :image_collection, null: false, foreign_key: true
      t.references :image_file, null: false, foreign_key: true

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }, null: false
    end
  end
end
