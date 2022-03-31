# frozen_string_literal: true

# Add qualified boolean to workers
class AddQualifiedToWorkers < ActiveRecord::Migration[6.1]
  def change
    add_column :workers, :qualified, :boolean, default: false
  end
end
