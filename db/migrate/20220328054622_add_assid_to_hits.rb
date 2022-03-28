# frozen_string_literal: true

# Add assignment_id to hits
class AddAssidToHits < ActiveRecord::Migration[6.1]
  def change
    add_column :hits, :assignment_id, :string
  end
end
