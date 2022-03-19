# frozen_string_literal: true

# Generate patterns migration
class CreatePatterns < ActiveRecord::Migration[6.1]
  def change
    create_table :patterns do |t|
      t.integer :index
      t.integer :length

      t.timestamps
    end
  end
end
