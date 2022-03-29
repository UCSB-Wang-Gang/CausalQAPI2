# frozen_string_literal: true

# Drop patterns table
class DropPatterns < ActiveRecord::Migration[6.1]
  def change
    drop_table :patterns
    add_column :passages, :patterns, :string, default: ''
  end
end
