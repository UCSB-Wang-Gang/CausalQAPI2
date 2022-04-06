# frozen_string_literal: true

# this allows for logic that lets us throw away passages have been skipped over a certain number of times
class AddRetrievedToPassages < ActiveRecord::Migration[6.1]
  def change
    add_column :passages, :retrieved, :integer, default: 0
  end
end
