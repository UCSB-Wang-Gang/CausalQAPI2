# frozen_string_literal: true

# Remove columns from hit
class SeparateHitColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :hits, :question, :string
    remove_column :hits, :answer, :string
    remove_column :hits, :explanation, :string
  end
end
