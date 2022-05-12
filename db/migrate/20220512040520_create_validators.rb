# frozen_string_literal: true

# Create validator table
class CreateValidators < ActiveRecord::Migration[6.1]
  def change
    create_table :validators do |t|
      t.integer :count
      t.string :username

      t.timestamps
    end
  end
end
