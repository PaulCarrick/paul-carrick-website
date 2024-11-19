# frozen_string_literal: true

class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.string :content_type, null: false
      t.integer :section_order
      t.string :image
      t.string :link
      t.string :formatting
      t.text :description

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }, null: false
    end
  end
end
