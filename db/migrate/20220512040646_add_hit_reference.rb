# frozen_string_literal: true

# Add reference to validator
class AddHitReference < ActiveRecord::Migration[6.1]
  def change
    add_reference :hits, :validator, foreign_key: true
  end
end
