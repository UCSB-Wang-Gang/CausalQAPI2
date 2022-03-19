# frozen_string_literal: true

# Generate passages migration
class CreatePassages < ActiveRecord::Migration[6.1]
  def change
    create_table :passages do |t|
      t.string :passage

      t.timestamps
    end
  end
end
