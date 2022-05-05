# frozen_string_literal: true

# adds eval (nil, good, bad, maybe ok)
class AddEvalToHits < ActiveRecord::Migration[6.1]
  def change
    add_column :hits, :eval, :string
  end
end
