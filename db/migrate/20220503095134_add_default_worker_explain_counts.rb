# frozen_string_literal: true

# Adds default counts to worker explain counts
class AddDefaultWorkerExplainCounts < ActiveRecord::Migration[6.1]
  def change
    change_column :workers, :explanation_submits, :integer, default: 0
    change_column :workers, :explanations_since_check, :integer, default: 0
  end
end
