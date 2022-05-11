# frozen_string_literal: true

# counts num bad s1 hits worker submits
class AddGoodS1CountToWorker < ActiveRecord::Migration[6.1]
  def change
    add_column :workers, :good_s1_count, :integer, default: 0
  end
end
