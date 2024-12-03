class CreateImageCollections < ActiveRecord::Migration[8.0]
  def change
    create_table :image_collections do |t|
      t.string :name, null: false

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }, null: false
    end

    add_index :image_collections, :name, unique: true
  end
end
