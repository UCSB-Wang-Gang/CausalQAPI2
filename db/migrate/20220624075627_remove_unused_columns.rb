# frozen_string_literal: true

# Removes columns that are no longer being used
class RemoveUnusedColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :workers, :qualified, :boolean
    remove_column :workers, :quiz_attempts, :integer
    remove_column :workers, :grammar_score, :decimal
  end
end
