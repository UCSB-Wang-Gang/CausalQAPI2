# frozen_string_literal: true

# Add columns to workers
class AddSubmissionsToWorkers < ActiveRecord::Migration[6.1]
  def change
    add_column :workers, :submissions, :integer
    add_column :workers, :submissions_since_check, :integer
    add_column :workers, :grammar_score, :decimal
  end
end
