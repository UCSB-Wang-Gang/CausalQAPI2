# frozen_string_literal: true

# Create workers migration
class CreateWorkers < ActiveRecord::Migration[6.1]
  def change
    create_table :workers do |t|
      t.string :worker_id
      t.integer :quiz_attempts

      t.timestamps
    end
  end
end
