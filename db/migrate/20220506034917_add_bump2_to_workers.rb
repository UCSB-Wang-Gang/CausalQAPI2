# frozen_string_literal: true

# separate bump for s2 so s1passed folks cannot mess up too much on s2
class AddBump2ToWorkers < ActiveRecord::Migration[6.1]
  def change
    add_column :workers, :bump2, :string, default: 'unchecked'
  end
end
