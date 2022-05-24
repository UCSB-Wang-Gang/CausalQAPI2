# frozen_string_literal: true

# Add count for ok evals for workers
class AddOkCountS2ToWorkers < ActiveRecord::Migration[6.1]
  def change
    add_column :workers, :ok_s2_count, :integer, default: 0
  end
end
