# frozen_string_literal: true

# Create explanation table
class CreateExplanations < ActiveRecord::Migration[6.1]
  def change
    create_table :explanations do |t|
      t.string :explanation

      t.timestamps
    end
  end
end
