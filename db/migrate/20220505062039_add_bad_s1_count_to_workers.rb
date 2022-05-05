# frozen_string_literal: true

# counts num bad s1 hits worker submits
class AddBadS1CountToWorkers < ActiveRecord::Migration[6.1]
  def change
    add_column :workers, :bad_s1_count, :integer, default: 0
  end
end
