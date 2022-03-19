# frozen_string_literal: true

# Generate hits migration
class CreateHits < ActiveRecord::Migration[6.1]
  def change
    create_table :hits do |t|
      t.string :question
      t.string :answer

      t.timestamps
    end
  end
end
