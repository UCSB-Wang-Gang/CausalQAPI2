# frozen_string_literal: true

# Adds explanation column to hits
class AddExplanationToHits < ActiveRecord::Migration[6.1]
  def change
    add_column :hits, :explanation, :string
  end
end
